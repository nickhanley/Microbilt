module Microbilt
  # Module to house configuration for the Microbilt gem
  module Configuration
    # Microbilt servers
    SERVER_PROD = 'https://creditserver.microbilt.com'
    SERVER_TEST = 'https://sdkstage.microbilt.com'

    # Service URI's
    INIT_URI = '/WebServices/IBV/Home/CreateForm'
    DATA_URI = '/WebServices/IBV/Home/GetData'
    FORM_URI = '/WebServices/IBV/Home/AddCustomer'

    # Options
    DEFAULT_SERVER      = :test
    DEFAULT_DATA_FORMAT = :json
    DEFAULT_CLIENT_ID   = nil
    DEFAULT_CLIENT_PASS = nil

    VALID_CONNECT_KEYS = [:client_id, :client_pass]
    VALID_OPTION_KEYS  = [:format, :server]
    VALID_CONFIG_KEYS  = VALID_OPTION_KEYS + VALID_CONNECT_KEYS

    attr_accessor *VALID_CONFIG_KEYS
    # attr_accessor :format, :server, :client_id, :client_pass

    def self.extended(base)
      base.reset
    end

    # Allow configuration to be reset to default values
    def reset
      self.server      = DEFAULT_SERVER
      self.format      = DEFAULT_DATA_FORMAT
      self.client_id   = DEFAULT_CLIENT_ID
      self.client_pass = DEFAULT_CLIENT_PASS
    end

    # Provide a way to configure the gem.
    def configure
      yield self
    end

    def options
      Hash[* VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten]
    end

  end
end
