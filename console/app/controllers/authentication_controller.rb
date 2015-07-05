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

  def reset_password
    session[:token] = params[:token]
  end

  def send_reset_token
    authentication = Authentication.new
    begin
        authentication.reset_password params[:login]
        flash[:success] = _("Password reset sent.")
    rescue
        flash[:error] = _("Error reseting password: %s") % _("Please contact support@getupcloud.com")
    end
    redirect_to signin_path
  end

  def update_password
    password = params[:password].to_s
    if password.length < 6
       flash[:error] = _('Password too short (min 6 characteres)')
       redirect_to :back
       return
    end

    authentication = Authentication.new
    res = authentication.update_password params[:password], session[:token]

    if res.content
      if res.content[:status] == 'ok'
        flash[:success] = res.content[:message]
        redirect_to signin_path
        return
      end
      flash[:error] = _('Unable to reset your password: %s') % res.content[:message]
    else
      flash[:error] = _('Unable to reset your password: %s') % _("Please contact support@getupcloud.com")
    end

    redirect_to :back
  end
end
