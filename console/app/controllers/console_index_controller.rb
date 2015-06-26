class ConsoleIndexController < ConsoleController
  skip_before_filter :authenticate_user!, :only => [:unauthorized, :server_unavailable]

  def index
    if session[:authentication]
      flash.keep
      redirect_to applications_path
    else
      redirect_to signin_path
    end
  end

  def unauthorized
    render 'console/unauthorized'
  end

  def server_unavailable
    render 'console/server_unavailable'
  end

  def help
    redirect_to 'https://getup.zendesk.com/hc'
    #render 'console/help'
  end
end
