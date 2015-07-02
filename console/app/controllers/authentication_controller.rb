class AuthenticationController < Console.config.parent_controller.constantize
  include Console::UserManagerHelper
  include Console::HelpHelper
  include LocaleAware

  layout 'authentication'

  def signin
  end

  def signout
    reset_session

    redirect_to signin_path
  end

  def auth
    authentication = Authentication.new
    authentication.generate params[:login], params[:password]
    session[:authentication] = authentication
    session[:lang] = user_manager_account_lang
    redirect_to applications_path
  end

  def change_password
    session[:token] = params[:token]
  end

  def send_reset_token
    authentication = Authentication.new
    begin
        authentication.reset_password params[:login]
        flash[:success] = "Password reset sent."
    rescue
        flash[:error] = "Error reseting password. Please contact suporte@getupcloud.com."
    end
    redirect_to signin_path
  end
end
