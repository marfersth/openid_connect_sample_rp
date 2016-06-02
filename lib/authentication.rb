module Authentication

  class AuthenticationRequired < StandardError; end
  class AnonymousAccessRequired < StandardError; end

  def self.included(klass)
    klass.send :include, Authentication::Helper
    klass.send :before_filter, :optional_authentication
    klass.send :cattr_accessor, :required_scopes
    klass.send :rescue_from, AuthenticationRequired,  with: :authentication_required!
    klass.send :rescue_from, AnonymousAccessRequired, with: :anonymous_access_required!
  end

  module Helper
    def current_account
      @current_account
    end

    def authenticated?
      !current_account.blank?
    end
  end

  def authentication_required!(e)
    redirect_to root_url, flash: {
      error: e.message || 'Authentication Required'
    }
  end

  def anonymous_access_required!(e)
    redirect_to account_url
  end

  def optional_authentication
    if session[:current_account]
      authenticate Account.find_by_id(session[:current_account])
    end
  rescue ActiveRecord::RecordNotFound
    unauthenticate!
  end

  def require_authentication
    raise AuthenticationRequired.new unless authenticated?
    # if access_token expires the refresh token is sanded to the OP, the aim is to get a new access_token
    authenticate_with_refresh_token if current_account.open_id.expires_at < DateTime.now.utc
  end

  def require_anonymous_access
    raise AnonymousAccessRequired.new if authenticated?
  end

  def authenticate(account)
    if account
      @current_account = account
      session[:current_account] = account.id
    end
  end

  def unauthenticate!
    @current_account = session[:current_account] = nil
  end

  def authenticate_with_refresh_token
    provider = Provider.find_by(issuer: Rails.application.config.openid_op_url)
    provider.re_authenticate(current_account.open_id.refresh_token)
  end
end