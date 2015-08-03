class AccountController < ConsoleController
  include Console::UserManagerHelper
  include Console::CommunityAware

  def show
    @user = current_user
    @plan = user_manager_account_plan.content
    @payment = @plan[:payment]
    @plan[:is_trial] = @plan[:status] == 'te' or @plan[:status] == 'tf'
    @capabilities = user_capabilities :refresh => true
    @getup_credit_url = getup_credit_url
    @has_credits = (@plan[:free_tier].to_f + @plan[:bonus].to_f + @plan[:voucher].to_f + @plan[:credit].to_f) > 0
  end
end
