require 'typhoeus'
require 'uri'

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

    # return a URL encoded string of all the MicroBilt parameters
    # to be used in the post body.
    def body_params
      URI.encode_www_form(
      {
        'MemberId' => Microbilt.options[:client_id],
        'MemberPwd' => Microbilt.options[:client_pass],
        'CallbackUrl' => @callback_url, 'CallbackType' => Microbilt.options[:format],
        'ContactBy' => @cust_contact_method,       # BOTH, SMS, EMAIL
        'Customer.FirstName' => @cust_firstname, 'Customer.LastName' => @cust_surname,
        'Customer.SSN' => @cust_sin, 'Customer.DOB' => @cust_dob, # format: MMDDYYYY
        'Customer.Address' => @cust_address, 'Customer.City' => @cust_city,
        'Customer.State' => @cust_state, 'Customer.ZIP' => @cust_zip,
        'Customer.Country' => 'CAN', # @cust_country,
        'Customer.Phone' => @cust_homephone, 'Customer.WorkPhone' => @cust_workphone,
        'Customer.CellPhone' => @cust_cellphone, 'Customer.Email' => @cust_email,
        'Customer.ABAnumber' => @cust_transitnum, 'Customer.AccountNumber' => @cust_accountnum
      })
    end

    # Invoked as the first step in the IBV process. The GUID is return
    def create_form
      req = Typhoeus::Request.new(server + Configuration::INIT_URI,
                                  method: :post, body: body_params,
                                  headers: { 'Content-Type' =>
                                  'application/x-www-form-urlencoded' })
      req.run
    end

    # Return an HTML formatted report
    def get_report_data(guid)
      req = Typhoeus.get(append_guid(server + Configuration::DATA_URI, guid))
      req.run
    end

    # public method to return the host of the server
    def server_name
      server
    end

    private

    # return the URL passed with the GUID as a reference parameter
    # Used for the AddCustomer and GetData requests.
    def append_guid(url, guid)
      url + "?reference=#{guid}"
    end

    # Return the hostname for the server we want to use, based on the @mode
    # attribute
    def server
      if @server == :production
        Configuration::SERVER_PROD
      else
        Configuration::SERVER_TEST
      end
    end

  end

end
