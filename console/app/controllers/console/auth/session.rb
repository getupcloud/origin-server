#
# The simplest possible security strategy - this controller mixin
# will challenge the user with BASIC authentication, pass that
# information to the broker, and then cache the ticket and the user
# identifier in the session until the ticket expires.
#
module Console::Auth::Session
  extend ActiveSupport::Concern

  class SessionUser < RestApi::Credentials
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    def initialize(login, password)
      @login = login
      @password = password

      authorization = ActionController::HttpAuthentication::Basic.encode_credentials login, password
      headers = {'Authorization' => authorization}

      @headers = headers.freeze
    end

    def email_address
      nil
    end

    def to_headers
      @headers
    end

    def persisted?
      false
    end
  end

  included do
    helper_method :current_user, :user_signed_in?, :previously_signed_in?

    rescue_from ActiveResource::UnauthorizedAccess, :with => :console_access_denied
  end

  # return the current authenticated user or nil
  def current_user
    @authenticated_user
  end

  # This method should test authentication and handle if the user
  # is unauthenticated
  def authenticate_user!
    return console_authentication unless session[:authentication]
    
    authentication = session[:authentication]
    return console_access_expired if authentication.expired?

    authentication.update_expires

    @authenticated_user = SessionUser.new authentication.login, authentication.password
  end

  def user_signed_in?
    not current_user.nil?
  end

  def previously_signed_in?
    cookies[:prev_login] ? true : false
  end

  protected
    def console_access_denied
      flash[:error] = "The console was unable to authenticate you with the OpenShift server."
      console_authentication
    end

    def console_access_expired
      flash[:error] = "Your session expired."
      console_authentication
    end

    def console_authentication
      redirect_to signin_path
    end
end
