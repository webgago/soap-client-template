require "soap-client-template/wsdl/instance"

class WSDLNotFoundError < StandardError; end

module Soap::Client::Template::WSDL
  class Reader

    attr_reader :location

    def initialize(location)
      @location = location
    end

    def read
      Instance.new File.read(location)
    rescue Errno::ENOENT
      raise WSDLNotFoundError, %Q{WSDL file expected on location "#{location}"}
    end

  end
end