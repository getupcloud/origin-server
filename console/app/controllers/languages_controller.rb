class LanguagesController < ConsoleController
  def update
    lang = params[:lang][:select]
    user_manager_account_lang_change lang
    session[:lang] = lang
    redirect_to settings_path
  end
end
