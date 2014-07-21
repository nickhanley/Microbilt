module Microbilt

  class Test

    def initialize(phrase)
      @phrase = phrase
    end

    def execute!
      req = Typhoeus.get("http://md5.jsontest.com/?text=#{phrase}")
      req.response
    end
  end

end
