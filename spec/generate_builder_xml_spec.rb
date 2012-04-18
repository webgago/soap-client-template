require "spec_helper"

describe "Generate Builder::XmlMarkup from wsdl/xsd" do
  include Soap::Client::Template

  before do
    @dir = Dir.mktmpdir
  end

  after do
    Dir["#{@dir}/*"].each { |f| File.delete(f) }
    Dir.rmdir @dir
  end

  let(:wsdl_location) { Pathname.new('../fixtures/UserService.wsdl').expand_path(__FILE__).to_s }
  let(:xsd_location) { Pathname.new('../fixtures/UserService.xsd').expand_path(__FILE__).to_s }

  let(:instance) { WSDL::Reader.new(wsdl_location).read }

  it "should rewrite xml to builder xml markup", :slow => true do
    xml_generator = WSDL::XMLGenerator.new xsd_location, instance

    Generator.new(xml_generator, converter: XmlToBuilderXmlConverter.new).generate :to_file, dir: @dir, ext: 'xml.builder'

    File.read("#{@dir}/get_first_name.xml.builder").should eql read_fixture_with_underscored_name('get_first_name.xml.builder')
    File.read("#{@dir}/get_last_name.xml.builder").should eql read_fixture_with_underscored_name('get_last_name.xml.builder')
  end


end