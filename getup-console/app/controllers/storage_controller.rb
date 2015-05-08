class StorageController < ConsoleController
  include Console::UserManagerHelper
  include Console::BillingHelper

  before_filter :user_information
  before_filter :application_information

  def show
    prices = user_manager_subscription_prices.content

    if I18n.locale.to_s == 'pt'
      price = item_price({:usage_type => 'ADDTL_FS_GB'}, prices)
    else
      price = item_price({:usage_type => 'ADDTL_FS_GB', :currency => 'USD'}, prices)
    end
    @storage_price = number_to_currency(price[:value], unit: price[:acronym], precision: 2)
  end

  def update
    @cartridge = @application.find_cartridge(params[:id]) or raise RestApi::ResourceNotFound.new(Cartridge.model_name, params[:id])

    @cartridge.additional_gear_storage = Integer(params[:cartridge][:additional_gear_storage])

    if @cartridge.save
      redirect_to application_storage_path, :flash => {:success => I18n.t(:storage_updated, cart: @cartridge.display_name)}
    else
      flash.now[:error] = @cartridge.errors.messages.values.flatten
      render :show
    end
  end

  private
  def user_information
    user_default_domain
    @user = User.find :one, :as => current_user
    @max_storage = @user.capabilities[:max_storage_per_gear] || 0
    @can_modify_storage = @max_storage > 0
  end

  def application_information
    @application = @domain.find_application params[:application_id]
    @gear_groups = @application.cartridge_gear_groups
  end
end
