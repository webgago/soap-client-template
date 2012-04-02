require "soap-client-template/version"

module Soap
  module Client
    module Template

      attr_reader :wsdl

      def initialize(wsdl)
        @wsdl = wsdl
      end

    end
  end
end
