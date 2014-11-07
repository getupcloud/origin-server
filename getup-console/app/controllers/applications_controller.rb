class ApplicationsFilter
  extend ActiveModel::Naming
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  attr_accessor :name, 'type', :type_options
  def initialize(attributes={})
    attributes.each { |key,value| send("#{key}=", value) } unless attributes.nil?
  end

  def persisted?
    false
  end

  def active?
    @filtered
  end

  def present?
    !(name.nil? or name.blank?) or !(type.nil? or type.blank?)
  end

  def apply(applications)
    @filtered = !applications.empty?
    @type_options = [['All','']]

    types = {}
    applications.select do |application|
      type = application.framework
      unless types.has_key? type
        @type_options << [application.framework_name, type]
        types[type] = true
      end

      ApplicationsFilter.wildcard_match?(@name, application.name) &&
        (@type.nil? or @type.blank? or @type == type)
    end
  end

  def self.wildcard_match?(search_str, value)
    return true if search_str.nil? || search_str.blank?

    if !(search_str =~ /\*/)
      search_str = "*" + search_str + "*"
    end

    # make the regexp safe
    wildcard_parse = search_str.split('*')
    wildcard_re = ""
    for element in wildcard_parse
      if element == ""
        wildcard_re += ".*"
      else
        wildcard_re += Regexp.escape(element)
      end
    end

    # check for wildcard as last char
    if search_str.ends_with? '*'
      wildcard_re += ".*"
    end

    wildcard_re = "^" + wildcard_re + "$"
    /#{wildcard_re}/.match(value)
  end

end

class ApplicationsController < ConsoleController
  include AsyncAware

  # trigger synchronous module load 
  [GearGroup, Cartridge, Key, Application] if Rails.env.development?

  def index
    # replace domains with Applications.find :all, :as => current_user
    # in the future
    #domain = Domain.find :one, :as => current_user rescue nil
    user_default_domain rescue nil
    return redirect_to application_types_path, :notice => I18n.t(:create_first_app) if @domain.nil? || @domain.applications.empty?

    @applications_filter = ApplicationsFilter.new params[:applications_filter]
    @applications = @applications_filter.apply(@domain.applications)
  end

  def destroy
    @domain = Domain.find :one, :as => current_user
    @application = @domain.find_application params[:id]
    if @application.destroy
      redirect_to applications_path, :flash => {:success => I18n.t(:app_deleted, name: @application.name)}
    else
      render :delete
    end
  end

  def delete
    #@domain = Domain.find :one, :as => current_user
    user_default_domain
    @application = @domain.find_application params[:id]

    @referer = application_path(@application)
  end

  def new
    redirect_to application_types_path
  end

  def gear_count_message
    #DUP: application_types_controller.rb
    flash.clear
    begin
      if @plan[:payment][:valid]
        flash.now[:warning] = I18n.t(:increase_max_gears_limit, max_gears: @capabilities.max_gears)
      else
        flash.now[:warning] = (I18n.t(:validate_your_account_1) + " <a href='#{account_path}'>" + I18n.t(:validate_your_account_2) + '</a>.').html_safe
      end
    rescue
    end
  end

  def create
    app_params = params[:application] || params
    @advanced = to_boolean(params[:advanced])
    type = params[:application_type] || app_params[:application_type]
    domain_name = app_params[:domain_name].presence || app_params[:domain_id].presence

    @application_type = (type == 'custom' || !type.is_a?(String)) ?
      ApplicationType.custom(type) :
      ApplicationType.find(type)

    @capabilities = user_capabilities :refresh => true

    @application = (@application_type >> Application.new(:as => current_user)).assign_attributes(app_params)

    begin
      @cartridges, @missing_cartridges = @application_type.matching_cartridges
      flash.now[:error] = I18n.t(:undef_cart_type) unless @cartridges.present?
    rescue ApplicationType::CartridgeSpecInvalid
      logger.debug $!
      flash.now[:error] = I18n.t(:invalid_cart_type, source: @application_type.source)
    end

    #@cartridges, @missing_cartridges = ApplicationType.matching_cartridges(@application.cartridge_names.presence || @application_type.cartridges)

    gear_count_message unless @capabilities.gears_free?
    @disabled = @missing_cartridges.present? || @cartridges.blank?

    # opened bug 789763 to track simplifying this block - with domain_name submission we would
    # only need to check that domain_name is set (which it should be by the show form)
    @domain = Domain.find :first, :as => current_user
    unless @domain
      @domain = Domain.create :name => domain_name, :as => current_user
      unless @domain.persisted?
        logger.debug "Unable to create domain, #{@domain.errors.to_hash.inspect}"
        @application.valid? # set any errors on the application object
        #FIXME: Ideally this should be inferred via associations between @domain and @application
        @domain.errors.values.flatten.uniq.each {|e| @application.errors.add(:domain_name, e) }

        return render 'application_types/show'
      end
    end
    @application.domain = @domain

    if @application.save
      messages = @application.remote_results

      redirect_to get_started_application_path(@application, :wizard => true), :flash => {:info_pre => messages}
    else
      logger.debug @application.errors.inspect

      render 'application_types/show'
    end
  end

  def show
    @domain = user_default_domain
    app_id = params[:id].to_s

    async{ @application = Application.find(app_id, :as => current_user, :params => {:include => :cartridges, :domain_id => @domain.id}) }
    async{ @gear_groups_with_state = GearGroup.all(:as => current_user, :params => {:application_name => app_id, :domain_id => @domain.id}) }
    async{ sshkey_uploaded? }

    join!(30)

    @gear_groups = @application.cartridge_gear_groups
    @gear_groups.each{ |g| g.merge_gears(@gear_groups_with_state) }
  end

  def get_started
    user_default_domain
    @application = @domain.find_application params[:id]

    @wizard = !params[:wizard].nil?
    sshkey_uploaded?
  end
end
