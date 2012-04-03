require "spec_helper"


describe 'WSDL Instance' do
  let(:wsdl_file) { Pathname.new('../fixtures/UserService.wsdl').expand_path(__FILE__).to_s }

  subject { WSDL::Reader.new(wsdl_file).read }

  it "should have Hash of binding name => binding node" do
    subject.binding_nodes.should be_a Hash
    subject.binding_nodes.values.each { |node| node.should be_a LibXML::XML::Node }
    subject.binding_nodes.values.each { |node| node.name.should eql 'binding' }
  end

  it "should have Hash of binding name => operation nodes" do
    subject.operation_nodes.should be_a Hash
    subject.operation_nodes.values.each { |nodes| nodes.each { |node| node.should be_a LibXML::XML::Node } }
    subject.operation_nodes.values.each { |nodes| nodes.each { |node| node.name.should eql 'operation' } }
  end

  it "should have Array of binding names" do
    subject.bindings.count.should eql 1
    subject.bindings.should eql ['UserServicePortBinding']
  end

  it "should have Hash of binding => operation names" do
    subject.operations.should be_a Hash
    subject.operations.keys.should eql subject.bindings
    subject.operations.values.should eql [["getFirstName", "getLastName"]]
  end
end