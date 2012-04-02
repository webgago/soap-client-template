require "spec_helper"

require "tmpdir"

describe "Generating xml templates" do

  let(:wsdl_file) { Pathname.new('../fixtures/UserService.wsdl').expand_path(__FILE__).to_s }
  let(:xsd_file) { Pathname.new('../fixtures/UserService.xsd').expand_path(__FILE__).to_s }

  subject { WSDL::Reader.new(wsdl_file).read }

  it "should read wsdl and return WSDL::Instance" do
    subject.should be_a WSDL::Instance
  end

  it "should raise WSDLNotFoundError" do
    expect { WSDL::Reader.new('not_existing_path').read }.should raise_error WSDLNotFoundError, /not_existing_path/
  end

  it "should have binding nodes" do
    subject.binding_nodes.should be_a Hash
    subject.binding_nodes.values.each { |node| node.should be_a LibXML::XML::Node }
    subject.binding_nodes.values.each { |node| node.name.should eql 'binding' }
  end

  it "should have operation nodes" do
    subject.operation_nodes.should be_a Hash
    subject.operation_nodes.values.each { |nodes| nodes.each { |node| node.should be_a LibXML::XML::Node } }
    subject.operation_nodes.values.each { |nodes| nodes.each { |node| node.name.should eql 'operation' } }
  end

  it "should read all bindings" do
    subject.bindings.count.should eql 1
  end

  it "should read all operations from each bindings" do
    subject.operations.should be_a Hash
    subject.operations.keys.should eql ['UserServicePortBinding']
    subject.operations.values.should eql [["getFirstName", "getLastName"]]
  end

  before do
    @dir = Dir.mktmpdir
  end

  let(:dir) { @dir}

  it "should generate template for all operations from each bindings to specify directory", :slow => true do
    generator = WSDL::XMLGenerator.new xsd_file, subject
    generator.compile to: dir
    Dir["#{dir}/*.xml"].count.should eql 2
  end


end