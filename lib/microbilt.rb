require 'microbilt/version'
require 'microbilt/configuration'
require 'microbilt/test'

# Microbilt is a GEM to invoke the bank verification services provided by
# Microbilt.
module Microbilt
  extend Configuration

  def new(options = {})
    Client.new(options)
  end

end
