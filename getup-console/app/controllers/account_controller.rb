class AccountController < ConsoleController
  include Console::HelpHelper
  include Console::UserManagerHelper

  def show
    @plan = user_manager_account_plan.content
    @payment = @plan[:payment]
    @capabilities = user_capabilities :refresh => true
    @getup_credit_url = getup_credit_url
  end
end
