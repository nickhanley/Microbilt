require 'typhoeus'

module Microbilt

  class Test

    def initialize(phrase)
      @phrase = phrase
    end

    def execute!
      req = Typhoeus::Request.new("http://md5.jsontest.com/?text=#{@phrase}", followlocation: true)
      response = req.run
      puts response.response_body
      response
    end
  end

end
