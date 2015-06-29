class PasswordController < ConsoleController
  before_filter :set_locale

  def new
  end

  def create

    authentication = session[:authentication]

    old_password = params[:'old-password']
    new_password = params[:password]
    verify_password = params[:'verify-password']

    return redirect_to new_password_path, :flash => {:error => _("Old password can't be blank.")} unless old_password.present?
    return redirect_to new_password_path, :flash => {:error => _("New password can't be blank.")} unless new_password.present?
    return redirect_to new_password_path, :flash => {:error => _("Password doesn't match confirmation.")} unless (new_password == verify_password)
    return redirect_to new_password_path, :flash => {:error => _("Invalid password.")} unless (old_password == authentication.password)

    response = authentication.change_password old_password, new_password
    response_code = response.code.to_i

    flash = if response_code >= 200 and response_code < 400
      {:success => _("Your password has been changed.")}
    else
      {:error => _("Error while changing your password.")}
    end

    redirect_to settings_path, :flash => flash rescue redirect_to settings_path
  end
end
