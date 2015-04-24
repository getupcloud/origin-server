module Console::UserManagerHelper
  include Console::UserManagerApiHelper
  # 
  # 

  def userinfo
    ui = Hash.new("")
    return ui if session.empty?
    session[:name] = user_manager_account_userinfo[:name] unless session[:name]
    ui[:login] = session[:authentication].login
    ui[:name] = session[:name]
    ui[:email] = session[:authentication].login
    ui
  end

  def user_manager_account_userinfo
    begin
      result = user_manager_get session[:authentication].login + _url('account_userinfo')
      result.content[:data][0]
    rescue
      {}
    end
  end

  def user_manager_account_lang
    begin
      result = user_manager_get session[:authentication].login + _url('account_lang')
      result.content[:lang]
    rescue
    end
  end

  def user_manager_account_lang_change(lang)
    user_manager_post session[:authentication].login + _url('account_lang'), :lang => lang
  end

  def user_manager_account_plan
  	user_manager_get session[:authentication].login + _url('account_plan')
  end

  def user_manager_account_password_change(login, password, new_password)
    user_manager_post login + _url('account_password_change'), :oldpassword => password, :password1 => new_password, :password2 => new_password
  end

  def user_manager_account_password_reset(email)
    user_manager_post _url('account_password_reset'), :email => email
  end

  def user_manager_account_password_reset_key(token, password)
    user_manager_post _url('account_password_reset_key') + token + "/", :password1 => password, :password2 => password
  end

  def user_manager_subscription_create
  	user_manager_post session[:authentication].login + _url('subscription_create'), :returnurl => confirm_validate_url, :cancelurl => cancel_validate_url
  end

  def user_manager_subscription_confirm
    user_manager_get session[:authentication].login + _url('subscription_confirm')
  end

  def user_manager_subscription_cancel
    user_manager_get session[:authentication].login + _url('subscription_cancel')
  end
  
  def user_manager_subscription_prices
    user_manager_get session[:authentication].login + _url('subscription_prices')
  end

  def user_manager_primary_address
    user_manager_get session[:authentication].login + _url('primary_address')
  end

  def user_manager_primary_address_update(params = {})
    user_manager_post session[:authentication].login + _url('primary_address'), params
  end
  
  def user_manager_billing_address
    user_manager_get session[:authentication].login + _url('billing_address')
  end

  def user_manager_billing_address_update(params = {})
    params[:is_billing] = !params[:is_billing]
    user_manager_post session[:authentication].login + _url('billing_address'), params
  end
  
  def user_manager_billing_history
    user_manager_get session[:authentication].login + _url('billing_history')
  end
  
  def user_manager_billing_invoice(id)
    user_manager_get session[:authentication].login + _url('billing_invoice') + id + '/'
  end

  def user_manager_billing_invoice_pdf(id)
    user_manager_get session[:authentication].login + _url('billing_invoice') + 'pdf/' + id + '/'
  end

  private
    def _url(url)
      Console.config.api[:user_manager][url]
    end  
end
