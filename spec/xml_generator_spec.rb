require "spec_helper"

require "tmpdir"

describe "WSDL::XMLGenerator. Generate xml from wsdl/xsd" do
  let(:wsdl_location) { Pathname.new('../fixtures/UserService.wsdl').expand_path(__FILE__).to_s }
  let(:xsd_location) { Pathname.new('../fixtures/UserService.xsd').expand_path(__FILE__).to_s }

  let(:instance) { WSDL::Reader.new(wsdl_location).read }
  let(:generator) { WSDL::XMLGenerator.new xsd_location, instance }

  it 'should respond to :to_a and return [[operation, xml]]' do
    generator.should respond_to :to_a
  end

  it "should generate template for all operations from each bindings to specify directory", :slow => true do
    generator.each do |wsdl_operation, xml|
      xml.should eql read_fixture_with_underscored_name(wsdl_operation << '.xml')
    end

    generator.count.should eql instance.operations.map(&:count).sum
  end
end