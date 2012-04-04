module Soap::Client::Template
  class Generator

    def initialize(messages, options = { })
      @messages = messages
      @converter = options[:converter] || lambda { |xml| xml }
    end

    def generate(strategy = :to_io, output = $stdout)
      @messages.each do |operation, xml|
        call strategy, [output, operation, @converter.call(xml)]
      end
    end

    private

    def to_file(output, operation, content)
      check_output!(:to_file, output)

      file = Pathname.new(output[:dir]).join(operation.underscore << '.' << output[:ext])

      file.open('w+') do |f|
        f << content
      end
    end

    def to_io(output, operation, content)
      check_output!(:to_io, output)
      output << "Operation: <#{operation}>\n"
      output << ("-" * 40 ) << "\n"
      output << "\n"
      output << content
    end

    def call(strategy, params)
      if respond_to? strategy, true
        send strategy, *params
      else
        raise NoMethodError, "strategy #{strategy.inspect} not found"
      end
    end

    def check_output!(strategy, out)
      case strategy
      when :to_file
        raise ArgumentError, "for :to_file strategy first parameter should be a Hash" unless out.is_a? Hash
        out.assert_valid_keys(:dir, :ext)
      when :to_io
        raise ArgumentError, "for :to_io strategy first parameter should respond to :print" unless out.respond_to? :<<
      end
    end
  end
end