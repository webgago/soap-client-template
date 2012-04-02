require "xml"

module WSDL
  class Instance
    attr_reader :root

    def initialize(wsdl_content)
      @root = LibXML::XML::Document.string(wsdl_content).root
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

    def find(attr, value)
      root.children.select { |e| e.send(attr) == value }
    end

  end
end