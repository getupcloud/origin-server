class AddressController < ConsoleController
  include Console::UserManagerHelper

  def edit_address(type)
    @type = type
    result = user_manager_address @type
    @address = result.content[:data][0]
    @action_path = account_address_primary_path if type == :primary
    @action_path = account_address_billing_path if type == :billing
  end

  def create_address(type)
    result = user_manager_address_update type, params
    redirect_to account_path
  end
end
