module WSDL
  class XMLGenerator
    include Enumerable

    attr_reader :instance, :xsd_filepath
    protected :instance, :xsd_filepath

    def initialize(xsd_filepath, wsdl_instance)
      @xsd_filepath, @instance = xsd_filepath, wsdl_instance
      @cached_xml = {}
    end

    def each(&block)
      instance.operations.each do |_, operations|
        operations.each do |operation|
          block.call operation.dup, generate_xml(operation)
        end
      end
    end

    private

    def generate_xml(operation)
      @cached_xml[operation] ||= `xsd2inst #{xsd_filepath} -name #{operation}`.chomp
    end

  end
end