class PasswordController < ConsoleController
  before_filter :set_locale

  def new
    Rails.logger.debug "password#new"
  end

  def create
Rails.logger.debug "Updating Password: #{params['old-password']} => #{params[:password]}"

    authentication = session[:authentication]

    old_password = params[:'old-password']
    new_password = params[:password]
    verify_password = params[:'verify-password']

    return redirect_to new_password_path, :flash => {:error => I18n.t(:passwd_change_error_1)} unless old_password.present?
    return redirect_to new_password_path, :flash => {:error => I18n.t(:passwd_change_error_2)} unless new_password.present?
    return redirect_to new_password_path, :flash => {:error => I18n.t(:passwd_change_error_3)} unless (new_password == verify_password)
    return redirect_to new_password_path, :flash => {:error => I18n.t(:passwd_change_error_4)} unless (old_password == authentication.password)

    response = authentication.change_password old_password, new_password
Rails.logger.debug "response:: #{response.body}"
    response_code = response.code.to_i

    flash = if response_code >= 200 and response_code < 400
      {:success => I18n.t(:passwd_changed)}
    else
      {:error => I18n.t(:passwd_change_error_4)}
    end


Rails.logger.debug "Updating Password: #{flash}"
    redirect_to settings_path, :flash => flash rescue redirect_to settings_path
  end
end
