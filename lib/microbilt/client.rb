require 'typhoeus'

module Microbilt
  #
  class Client
    attr_accessor *(Configuration::VALID_CONFIG_KEYS)

    def initialize(options = {})
      merged_options = Microbilt.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    # Invoked as the first step in the IBV process. The GUID is return
    def create_form
      request = Typhoeus::Request.new(server + Configuration::INIT_URI,
                  method: :post, body: body_params,
                  headers: { 'Content-Type' =>
                             'application/x-www-form-urlencoded' }
      )
      request.response
    end

    # Return an HTML formatted report
    def get_report_data(guid)
      req = Typhoeus.get(append_guid(server + Configuration::DATA_URI, guid))
      req.response
    end

    # public method to return the host of the server
    def server_name
      server
    end

    private

    # return the URL passed with the GUID as a reference parameter
    # Used for the AddCustomer and GetData requests.
    def append_guid(base, guid)
      base + "?reference=#{guid}"
    end

    # Return the hostname for the server we want to use, based on the @mode
    # attribute
    def server
      if @mode == :production
        Configuration::Server_PROD
      else
        Configuration::Server_TEST
      end
    end

  end

end
