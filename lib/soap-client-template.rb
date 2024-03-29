require "soap-client-template/version"
require "active_support/core_ext/enumerable"
require "active_support/core_ext/string/inflections"
require "active_support/core_ext/string/access"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/class"
require "active_support/core_ext/class/attribute"
require "active_support/deprecation"
require "active_support/core_ext/module"
require "active_support/core_ext/hash/keys"

require "rails"
require "fileutils"
require "soap-client-template/wsdl"
require "soap-client-template/generator"
require "soap-client-template/xml_to_builder_xml_converter"

module Soap
  module Client
    module Template

      mattr_accessor :xsd2inst_path
      self.xsd2inst_path = File.expand_path('../../vendor/xmlbeans-2.5.0/bin/xsd2inst', __FILE__)

      mattr_accessor :enable_comments
      self.enable_comments = false

      mattr_accessor :override_files
      self.override_files = false

      class Railtie < ::Rails::Railtie
        rake_tasks do
          load "rails/tasks/soap-templates.rake"
        end
      end

      def self.generate(wsdl, xsd, dir, operation=nil)
        wsdl_instance = WSDL::Reader.new(wsdl).read
        xml = WSDL::XMLGenerator.new xsd, wsdl_instance, operation
        generator = Generator.new(xml, converter: XmlToBuilderXmlConverter.new)
        FileUtils.mkdir_p dir
        generator.generate :to_file, dir: dir, ext: 'xml.builder'
      end
    end
  end
end