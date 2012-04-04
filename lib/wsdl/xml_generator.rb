module WSDL
  class XMLGenerator
    include Enumerable

    attr_reader :instance, :xsd_filepath
    protected :instance, :xsd_filepath

    def initialize(xsd_filepath, wsdl_instance)
      @xsd_filepath, @instance = xsd_filepath, wsdl_instance
      @cached_xml = { }

      raise ArgumentError, "path to xsd file not specify" unless @xsd_filepath.present?
      raise ArgumentError, "instance of wsdl not specify" unless wsdl_instance.is_a? WSDL::Instance
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
      @cached_xml[operation] ||= begin
        elements = instance.get_element_names operation
        elements.map do |element_name|
          `xsd2inst #{xsd_filepath} -name #{element_name}`.chomp.tap do |xml|
            raise ArgumentError, "Generating XML Error: " << xml << " in #{xsd_filepath}" if xml.first != '<'
          end
        end.join("\n")
      end
    end

  end
end