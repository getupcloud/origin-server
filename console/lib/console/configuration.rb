require 'active_support/configurable'
require 'active_support/core_ext/hash'
require 'console/config_file'

module Console

 # Configures global settings for Console
 # Console.configure do |config|
 # config.disable_assets = 10
 # end
 def self.configure(file=nil,&block)
   config.send(:load, file) if file
   yield config if block_given?
 end

 # Global settings for Console
 def self.config
   @config ||= Configuration.new
 end

 class InvalidConfiguration < StandardError ; end

 class Configuration #:nodoc:
    include ActiveSupport::Configurable

    config_accessor :disable_static_assets
    config_accessor :parent_controller

    config_accessor :security_controller
    config_accessor :remote_user_header
    config_accessor :remote_user_name_header
    config_accessor :remote_user_copy_headers

    config_accessor :disable_account
    config_accessor :cartridge_type_metadata
    config_accessor :include_helpers

    config_accessor :community_url
    config_accessor :cache_store
    config_accessor :prohibited_email_domains
    config_accessor :syslog_enabled

    config_accessor :authentication_session_key
    config_accessor :authentication_session_expire
    config_accessor :session_user_name

    config_accessor :user_manager

    config_accessor :locales

    #
    # A class that represents the capabilities object
    #
    # Must implement:
    #
    #   - new(User)
    #   - from(<session_object>)
    #   - #to_session => <session_object>
    #
    config_accessor :capabilities_model

    Builtin = {
      :openshift => {
        :url => 'https://openshift.redhat.com/broker/rest',
      },
      :local => {
        :url => 'https://localhost/broker/rest',
      }
    }
    Builtin.freeze

    def api=(config)
      config = case
        when Builtin[config]
          source = config
          Builtin[config]
        when config == :external
          source = ENV['CONSOLE_CONFIG_FILE'].presence || '~/.openshift/console.conf'
          api_config_from(Console::ConfigFile.new(source))
        when config.respond_to?(:[])
          source = 'object in config'
          Builtin[:openshift].with_indifferent_access.merge(config)
        else
          raise InvalidConfiguration, "Invalid argument to Console.config.api #{config.inspect}"
        end

      unless config[:url]
        raise InvalidConfiguration, <<-EXCEPTION.strip_heredoc
          The console requires that Console.config.api be set to a symbol or endpoint configuration object.  Active configuration is #{Rails.env}

          '#{config.inspect}' via #{source} is not valid.

          Valid symbols: #{Builtin.each_key.collect {|k| ":#{k}"}.concat([:external]).join(', ')}
          Valid api object:
            {
              :url => '' # A URL pointing to the root of the REST API, e.g.
                         # https://openshift.redhat.com/broker/rest
            }
        EXCEPTION
      end

      freeze_api(config, source)
    end
    def api
      @api
    end

    def cartridge_type_metadata
      @cartridge_type_metadata || File.expand_path(File.join('config', 'cartridge_types.yml'), Console::Engine.root)
    end

    def user_agent
      @user_agent ||= "openshift_console/#{Console::VERSION::STRING} (ruby #{RUBY_VERSION}; #{RUBY_PLATFORM})"
    end
    def user_agent=(agent)
      @user_agent = agent
    end

    def capabilities_model_class
      @capabilities_model_class ||= @capabilities_model.constantize
    end
    def capabilities_model=(name)
      @capabilities_model_class = nil
      @capabilities_model = name
    end

    def env_bool(sym, default=nil, &block)
      b = env(sym, default, &block)
      raise InvalidConfiguration, "#{sym} must be true or false, was #{b.inspect}" unless (b == true || b == false)
      b
    end

    #
    # Retrieve a configuration value from the default environment
    #
    # Pass an optional block to modify the value
    #
    def env(sym, default=nil, &block)
      env = if @config
        v = @config[sym]
        v.nil? ? default : to_ruby_value(v)
      else
        default
      end
      env = yield env if block_given? && !env.nil?
      env
    end

    protected

      def load(file)
        config = @config = Console::ConfigFile.new(file)
        raise InvalidConfiguration, "BROKER_URL not specified in #{file}" unless config[:BROKER_URL]
        raise InvalidConfiguration, "LOCAL_BROKER_BASE_URL not specified in #{file}" unless config[:LOCAL_BROKER_BASE_URL]

        freeze_api(api_config_from(config), file)

        self.community_url = config[:COMMUNITY_URL]
        if self.community_url && !self.community_url.end_with?('/')
          raise InvalidConfiguration, "COMMUNITY_URL must end in '/'"
        end

        self.prohibited_email_domains = config[:PROHIBITED_EMAIL_DOMAINS].split(',').map { |email| email.strip } rescue []

        if self.syslog_enabled = config[:SYSLOG_ENABLED]
          require 'syslog-logger'
          Rails.configuration.logger = Logger::Syslog.new('openshift-console')
        end

        if cache_store = config[:CACHE_STORE]
          Rails.configuration.send(:cache_store=, eval("[#{cache_store}]"))
        end

        if default_host = config[:DEFAULT_URL_OPTIONS_HOST]
          (Rails.configuration.action_controller.default_url_options ||= {})[:host]  = default_host
        end

        if default_port = config[:DEFAULT_URL_OPTIONS_PORT]
          (Rails.configuration.action_controller.default_url_options ||= {})[:port] = default_port.empty? ? nil : default_port
        end

        if asset_host = config[:ASSET_HOST]
          Rails.configuration.action_controller.asset_host = asset_host
        end

        case config[:CONSOLE_SECURITY]
        when 'session'
          raise InvalidConfiguration, "AUTH_SESSION_KEY not specified in #{file}" unless config[:AUTH_SESSION_KEY]

          self.authentication_session_key = config[:AUTH_SESSION_KEY]
          self.authentication_session_expire = config[:AUTH_SESSION_EXPIRE] || 3600

          self.security_controller = 'Console::Auth::Session'
          self.session_user_name = config[:SESSION_USER_NAME] || 'X-Remote-User'
        when 'basic'
          self.security_controller = 'Console::Auth::Basic'
        when 'remote_user'
          self.security_controller = 'Console::Auth::RemoteUser'
          [:remote_user_copy_headers, :remote_user_header, :remote_user_name_header].each do |s|
            value = config[s.upcase]
            self.send(:"#{s}=", s.to_s.ends_with?('s') ? value.split(',') : value) if value
          end
        when String
          self.security_controller = config[:CONSOLE_SECURITY]
        end

        if locales = config[:LOCALES]
          Rails.configuration.locales = locales.split(',').each{|item| item.strip}
        else
          Rails.configuration.locales = ['en']
        end
      end

      def to_ruby_value(s)
        case
        when s == nil
          nil
        when s[0] == '{', s[0] == '[', s[0] == '"', s[0] == "'"
          eval(s)
        when s[0] == ':'
          s[1..-1].to_sym
        when s =~ /^\d+$/
          s.to_i
        when s == 'true'
          true
        when s == 'false'
          false
        else
          s
        end
      end

      def api_config_from(config)
        config.inject(HashWithIndifferentAccess.new) do |h, (k, v)|
          if match = /^BROKER_API_(.*)/.match(k)
            h[match[1].downcase] = to_ruby_value(v)
          end
          h
        end.merge({
          :url    => config[:BROKER_URL],
          :proxy  => config[:BROKER_PROXY_URL],
          :user_manager => {
            :api => config[:LOCAL_BROKER_BASE_URL],
            :account_plan => config[:USER_MANAGER_ACCOUNT_PLAN_URL],
            :account_lang => config[:USER_MANAGER_ACCOUNT_LANG_URL],
            :account_userinfo => config[:USER_MANAGER_ACCOUNT_USERINFO_URL],
            :account_password_change => config[:USER_MANAGER_ACCOUNT_PASSWORD_CHANGE_URL],
            :account_password_reset => config[:USER_MANAGER_ACCOUNT_PASSWORD_RESET_URL],
            :account_password_reset_key => config[:USER_MANAGER_ACCOUNT_PASSWORD_RESET_KEY_URL],
            :validate => config[:USER_MANAGER_VALIDATE_URL],
            :subscription => config[:USER_MANAGER_SUBSCRIPTION_URL],
            :subscription_create  => config[:USER_MANAGER_SUBSCRIPTION_CREATE_URL],
            :subscription_confirm => config[:USER_MANAGER_SUBSCRIPTION_CONFIRM_URL],
            :subscription_cancel  => config[:USER_MANAGER_SUBSCRIPTION_CANCEL_URL],
            :subscription_prices  => config[:USER_MANAGER_SUBSCRIPTION_PRICES_URL],
            :primary_address => config[:USER_MANAGER_PRIMARY_ADDRESS_URL],
            :billing_address => config[:USER_MANAGER_BILLING_ADDRESS_URL],
            :billing_history => config[:USER_MANAGER_BILLING_HISTORY_URL],
            :billing_invoice => config[:USER_MANAGER_BILLING_INVOICE_URL],
          }
        })
      end

      def freeze_api(config, source)
        @api = {
          :user_agent => user_agent,
        }.with_indifferent_access.merge(config)
        @api[:source] = source
        @api.freeze
      end
  end

  configure do |config|
    config.disable_static_assets = false
    config.disable_account = false
    config.parent_controller = 'ApplicationController'
    config.security_controller = 'Console::Auth::Basic'
    config.include_helpers = true
    config.capabilities_model = 'Capabilities::Cacheable'
    config.authentication_session_expire = 3600
    config.session_user_name = 'X-Remote-User'
  end
end
