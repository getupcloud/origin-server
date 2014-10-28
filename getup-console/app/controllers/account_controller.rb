class AccountController < ConsoleController
  include Console::UserManagerHelper
  include Console::CommunityHelper

  def show
    @plan = user_manager_account_plan.content
    @payment = @plan[:payment]
    @capabilities = user_capabilities :refresh => true
    @getup_credit_url = getup_credit_url
  end
end
