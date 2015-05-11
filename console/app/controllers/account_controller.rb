class AccountController < ConsoleController
  include Console::UserManagerHelper
  include Console::CommunityHelper

  def show
    @user = current_user
    @plan = user_manager_account_plan.content
    @payment = @plan[:payment]
    @capabilities = user_capabilities :refresh => true
    @getup_credit_url = getup_credit_url
    @has_credits = @plan[:free_tier].to_i > 0 or @plan[:bonus].to_f > 0 or @plan[:voucher].to_f > 0 or @plan[:credit].to_f > 0
  end
end
