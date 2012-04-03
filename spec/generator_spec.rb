require "spec_helper"

require "tmpdir"

describe "Generate xml from wsdl/xsd" do

  before do
    @dir = Dir.mktmpdir
  end

  after do
    Dir["#{dir}/*.xml"].each { |f| File.delete(f) }
    Dir.rmdir @dir
  end

  let(:wsdl_location) { Pathname.new('../fixtures/UserService.wsdl').expand_path(__FILE__).to_s }
  let(:xsd_location) { Pathname.new('../fixtures/UserService.xsd').expand_path(__FILE__).to_s }

  let(:instance) { WSDL::Reader.new(wsdl_location).read }
  let(:dir) { @dir }


  it "should generate template for all operations from each bindings to specify directory", :slow => true do
    generator = WSDL::XMLGenerator.new xsd_location, instance
    generator.compile to: dir

    Dir["#{dir}/*.xml"].count.should eql instance.operations.map(&:count).sum
  end

end