module Soap::Client::Template::WSDL
  class XMLGenerator
    include Enumerable

    attr_reader :instance, :xsd_filepath
    protected :instance, :xsd_filepath

    def initialize(xsd_filepath, wsdl_instance, operation=nil)
      @xsd_filepath, @instance, @operation = xsd_filepath, wsdl_instance, operation
      @cached_xml = { }

      raise ArgumentError, "path to xsd file not specify" unless @xsd_filepath.present?
      raise ArgumentError, "instance of wsdl not specify" unless wsdl_instance.is_a? Instance
    end

    def each(&block)
      instance.operations.each do |_, operations|
        operations.each do |operation|
          next if @operation && operation != @operation
          block.call operation.dup, generate_xml(operation)
        end
      end
    end

    private

    def generate_xml(operation)
      @cached_xml[operation] ||= begin
        elements = instance.get_element_names operation
        elements.map do |element_name|
          `#{Soap::Client::Template.xsd2inst_path} #{xsd_filepath} -name #{element_name}`.chomp.tap do |xml|
            raise ArgumentError, "Generating XML Error: " << xml << " in #{xsd_filepath}" if xml.first != '<'
          end
        end.join("\n")
      end
    end

  end
end