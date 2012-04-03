module WSDL
  class XmlToBuilderXmlRewriter

    attr_reader :xml

    attr_accessor :buf, :level
    protected :buf, :buf=, :level, :level=

    def initialize(xml)
      @xml = xml
    end

    def rewrite
      @buf = StringIO.new ""
      @level = 0
      rewrite_to_builder(xml)
    end

    private

    def rewrite_to_builder(xml)
      root = LibXML::XML::Document.string(xml).root

      attrs = root.namespaces.to_a.inject({}) { |hash, item| hash.merge "xmlns:#{item.prefix}" => item.href }
      build_node_with_children(root, attrs)

      buf.string.strip
    end

    def build_node_with_children(node, attrs = {})
      buf.print spacer + "xml.#{tag_name(node)}"
      build_attributes node, attrs
      buf.puts " do"

      inc_level!
      node.each do |child|
        if child.children.any?(&:element?)
          build_node_with_children child
        else
          build_node child
        end
      end
      dec_level!

      buf.puts spacer + 'end'
    end

    def build_node(node)
      case node.node_type_name
        when 'comment'
          buf.puts spacer + "xml.comment! '#{node.content}'"

        when 'element'
          if node.namespaces.namespace
            buf.puts spacer + "xml.#{tag_name(node)}, '#{node.content}'"
          else
            buf.puts spacer + "xml.#{tag_name(node)} '#{node.content}'"
          end
      end
    end

    def build_attributes(node, attrs = {})
      attrs = (node.attributes.to_a).inject({ }) { |hash, item| hash.merge item.name => item.value }.merge attrs

      unless attrs.empty?
        buf.print ', '
        buf.print attrs.inspect
      end
    end

    def tag_name(node)
      if ns = node.namespaces.namespace
        "#{ns.prefix} :#{node.name}"
      else
        "#{node.name}"
      end
    end

    def inc_level!
      self.level = self.level + 1
    end

    def dec_level!
      self.level = self.level - 1
    end

    def spacer
      "  " * self.level
    end
  end
end