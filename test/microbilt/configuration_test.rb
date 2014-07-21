require 'helper'

# after do
#   Microbilt.reset
# end

describe '.configure' do
  Microbilt::Configuration::VALID_CONFIG_KEYS.each do |key|
    it "should set #{key}" do
      Microbilt.configure do |config|
        config.send("#{key}=", key)
        Microbilt.send(key).must_equal key
      end
    end
  end
end
