require "soap-client-template/version"
require "active_support/core_ext/enumerable"
require "active_support/core_ext/string/inflections"
require "active_support/core_ext/string/access"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/class"
require "active_support/core_ext/hash/keys"

require "wsdl"
require "soap-client-template/generator"
require "soap-client-template/xml_to_builder_xml_converter"

module Soap
  module Client
    module Template
      class Railtie < ::Rails::Railtie
        rake_tasks do
          load "rails/tasks/soap-templates.rake"
        end
      end

      def self.generate(wsdl, xsd, dir)
        wsdl_instance = WSDL::Reader.new(wsdl).read
        xml = WSDL::XMLGenerator.new xsd, wsdl_instance
        generator = Generator.new(xml, converter: XmlToBuilderXmlConverter.new)
        generator.generate :to_file, dir: dir, ext: 'xml.builder'
      end
    end
  end
end