require "spec_helper"

describe "WSDL Reader" do
  let(:wsdl_location) { Pathname.new('../fixtures/UserService.wsdl').expand_path(__FILE__).to_s }

  it "should read wsdl and return instance of WSDL::Instance" do
     WSDL::Reader.new(wsdl_location).read.should be_a WSDL::Instance
  end

  it "should raise WSDLNotFoundError if wsdl_location does not exist" do
    expect { WSDL::Reader.new('fake_wsdl_location').read }.should raise_error WSDLNotFoundError, /fake_wsdl_location/
  end

end