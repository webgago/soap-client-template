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
  let(:generated_files) { Dir["#{dir}/*.xml"] }


  it "should generate template for all operations from each bindings to specify directory", :slow => true do
    generator = WSDL::XMLGenerator.new xsd_location, instance
    generator.compile to: dir

    generated_files.count.should eql instance.operations.map(&:count).sum
    generated_files.each do |filename|
      File.read(filename).should eql read_fixture_with_underscored_name(filename)
    end
  end

end