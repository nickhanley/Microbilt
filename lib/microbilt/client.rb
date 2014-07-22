require 'typhoeus'
require 'uri'

module Microbilt
  #
  class Client
    attr_accessor *(Configuration::VALID_CONFIG_KEYS)
    # Perhaps move customer info into a customer class?
    attr_accessor :callback_url, :cust_contact_method,
                  :cust_firstname, :cust_surname, :cust_sin,
                  :cust_dob, :cust_dob, :cust_address, :cust_city,
                  :cust_state, :cust_zip, :cust_country,
                  :cust_homephone, :cust_workphone,
                  :cust_cellphone, :cust_email,
                  :cust_transitnum, :cust_accountnum

    # Create a new Microbilt client to provide access to
    # services.
    def initialize(options = {})
      merged_options = Microbilt.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    # Invoked as the first step in the IBV process. The returned data
    # is either a human readable error message, or a GUID for the
    # remaining steps in the workflow.
    def create_form
      req = Typhoeus::Request.new(server + Configuration::INIT_URI,
                                  method: :post, body: body_params,
                                  headers: { 'Content-Type' =>
                                  'application/x-www-form-urlencoded' })
      req.run
    end

    # Return an HTML formatted report
    def get_report_data(guid)
      stamped = append_time(guid)
      req = Typhoeus.get(append_guid(server + Configuration::DATA_URI, stamped))
      req.run
    end

    # generate the URL required for displaying the initial IBV form to the user
    def form_popup_url(guid)
      append_guid(server + Configuration::FORM_URI, guid)
    end

    private

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
        'Customer.Country' => @cust_country,
        'Customer.Phone' => @cust_homephone, 'Customer.WorkPhone' => @cust_workphone,
        'Customer.CellPhone' => @cust_cellphone, 'Customer.Email' => @cust_email,
        'Customer.ABAnumber' => @cust_transitnum, 'Customer.AccountNumber' => @cust_accountnum
      })
    end

    # return the URL passed with the GUID as a reference parameter
    # Used for the AddCustomer and GetData requests.
    def append_guid(url, guid)
      url + "?reference=#{guid}"
    end

    # append a timestamp param to prevent caching.
    def append_time(url)
      url + "?ts=#{Time.now.strftime('%Y%m%d%H%M%S%L')}"
    end

    # Return the hostname for the server we want to use, based on the @server
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
