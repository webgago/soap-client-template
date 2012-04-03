module WSDL
  class XMLGenerator

    attr_reader :instance, :xsd_filepath

    def initialize(xsd_filepath, wsdl_instance)
      @xsd_filepath, @instance = xsd_filepath, wsdl_instance
    end

    def compile(options = { }, &block)
      options = { ext: 'xml' }.merge options

      instance.operations.each do |_, operations|
        operations.each do |operation|
          xml = `xsd2inst #{xsd_filepath} -name #{operation}`.chomp
          write xml, operation.dup, options.dup, &block
        end
      end
    end

    private
    def write(xml, operation, options, &block)
      Pathname.new(options[:to]).join(operation << '.' << options[:ext]).open('w+') do |f|
        f << block.call(xml, operation, options)
      end
    end

  end
end