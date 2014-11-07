class ApplicationTypesController < ConsoleController

  include Console::ModelHelper
  include Console::UserManagerHelper

  def gear_count_message
    #DUP: applications_controller.rb
    flash.clear
    begin
      if @plan[:payment][:valid]
        flash.now[:warning] = I18n.t(:increase_max_gears_limit, max_gears: @capabilities.max_gears)
      elsif @plan[:status] == 'bt'
        flash.now[:warning] = ("<a href='#{account_path}'>#{I18n.t :unlock_your_account_click_here}</a> #{I18n.t :unlock_your_account_text}").html_safe
      else
        flash.now[:warning] = (I18n.t(:validate_your_account_1) + " <a href='#{account_path}'>" + I18n.t(:validate_your_account_2) + '</a>.').html_safe
      end
    rescue
    end
  end

  def index
    @capabilities = user_capabilities
    @plan = user_manager_account_plan.content

    gear_count_message unless @capabilities.gears_free?

    @browse_tags = [
      ['Java', :java],
      ['PHP', :php],
      ['Ruby', :ruby],
      ['Python', :python],
      ['Node.js', :nodejs],
      ['Perl', :perl],
      nil,
      [I18n.t(:all_web_carts), :cartridge],
      [I18n.t(:all_inst_apps), :instant_app],
      nil,
      ['Blogs', :blog],
      ['CMS', :cms],
      ['Cache', :cache],
      ['Big Data', :big_data],
    ]

    if @tag = params[:tag].presence
      types = ApplicationType.tagged(@tag)
      @type_groups = [["Tagged with #{Array(@tag).to_sentence}", types.sort!]]

      render :search
    elsif @search = params[:search].presence
      types = ApplicationType.search(@search)
      @type_groups = [["Matches search '#{@search}'", types]]

      render :search
    else
      types = ApplicationType.all
      @featured_types = types.select{ |t| t.tags.include?(:featured) }.sample(3).sort!
      groups, other = in_groups_by_tag(types - @featured_types, [:instant_app, :java, :php, :ruby, :python])
      groups.each do |g|
        g[2] = application_types_path(:tag => g[0])
        g[1].sort!
        g[0] = I18n.t(g[0], :scope => :types, :default => g[0].to_s.titleize)
      end
      groups << ['Other types', other.sort!] unless other.empty?
      @type_groups = groups
    end
  end

  def show
    app_params = params[:application] || params
    app_type_params = params[:application_type] || app_params
    @advanced = to_boolean(params[:advanced])

    user_default_domain rescue (@domain = Domain.new)

    @compact = false # @domain.persisted?

    @application_type = params[:id] == 'custom' ?
      ApplicationType.custom(app_type_params) :
      ApplicationType.find(params[:id])

    @capabilities = user_capabilities :refresh => true

    @application = (@application_type >> Application.new(:as => current_user)).assign_attributes(app_params)
    @application.gear_profile = @capabilities.gear_sizes.first unless @capabilities.gear_sizes.include?(@application.gear_profile)
    @application.domain_name = app_params[:domain_name].presence || app_params[:domain_id].presence

    begin
      @cartridges, @missing_cartridges = @application_type.matching_cartridges
      flash.now[:error] = I18n.t(:undef_cart_type) unless @cartridges.present?
    rescue ApplicationType::CartridgeSpecInvalid
      logger.debug $!
      flash.now[:error] = I18n.t(:invalid_cart_type, source: @application_type.source)
    end

    gear_count_message unless @capabilities.gears_free?
    @disabled = @missing_cartridges.present? || @cartridges.blank?

    user_default_domain rescue nil
  end
end
