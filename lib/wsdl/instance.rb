require "xml"

module WSDL
  class Instance
    attr_reader :root

    def initialize(wsdl_content)
      @doc = LibXML::XML::Document.string(wsdl_content)
      @root = @doc.root
    end

    def bindings
      @bindings ||= binding_nodes.keys
    end

    def operations
      @operations ||= operation_nodes.inject({ }) do |hash, (binding_name, nodes)|
        hash.merge binding_name => nodes.map { |node| node.attributes['name'] }
      end
    end

    def binding_nodes
      @binding_nodes ||= find(:name, 'binding').inject({ }) { |hash, node| hash.merge node.attributes['name'] => node }
    end

    def operation_nodes
      @operations_nodes ||= begin
        binding_nodes.inject({ }) { |hash, (key, node)| hash.merge key => node.children.select { |e| e.name == 'operation' } }
      end
    end

    def get_element_names(operation, type = 'input')
      message_elements = binding_nodes.values.map do |b|
        operation = port_type(b).children.find do |element|
          element.name =='operation' && element.attributes['name'] == operation
        end
        operation.children.find do |element|
          element.name == type
        end.attributes['message'].split(':').last
      end

      if message_elements.count > 1
        warn("Few message elements was found in wsdl with targetNamespace=#{target_namespace} #{message_elements.inspect}")
      end
      get_message_elements(message_elements.first)
    end

    def get_message_elements(message_name)
      parts = @root.children.find { |e| e.name == 'message' && e.attributes['name'] == message_name }.children.select do |e|
        e.name == 'part' && e.attributes['name']
      end
      parts.map do |p|
        p.attributes['element'].split(':').last
      end
    end

    def binding_name(binding)
      binding.attributes['type'].split(':').last
    end

    def port_type(binding)
      @root.children.select { |element| element.name == 'portType' }.
          find { |element| element.attributes['name'] == binding_name(binding) }
    end

    def target_namespace
      @root.attributes['targetNamespace']
    end

    def find(attr, value)
      root.children.select { |e| e.send(attr) == value }
    end

  end
end