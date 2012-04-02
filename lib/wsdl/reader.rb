require "wsdl/instance"

class WSDLNotFoundError < StandardError; end

module WSDL
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