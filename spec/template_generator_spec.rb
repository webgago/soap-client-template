require "spec_helper"

describe Soap::Client::Template::Generator do
  include Soap::Client::Template

  context ".new" do
    it "should accept one param: messages" do
      described_class.new(mock).should be_a described_class
    end
  end

  context "#generate" do
    before(:each) do
      @xml_generator_mock = mock
      @xml_generator_mock.stub(:each).and_yield('getFirstName', read_fixture_with_underscored_name('get_first_name.xml'))

      $stdout = StringIO.new ""

      @dir = Dir.mktmpdir
    end

    after do
      Dir["#{@dir}/*"].each { |f| File.delete(f) }
      Dir.rmdir @dir
    end

    subject { Soap::Client::Template::Generator.new @xml_generator_mock }

    it "should have a param named as 'strategy'" do
      subject.should respond_to :generate
      subject.method(:generate).parameters.should eql [[:opt, :strategy], [:opt, :output]]
    end

    it "should call messages.each which accept a block with |operation, xml| params" do
      @xml_generator_mock.should_receive(:each).and_yield('operation', 'xml')
      subject.generate
    end

    it "should call strategy method for messages, by default is :to_io" do
      @xml_generator_mock.stub(:each).and_yield('operation', '<xml/>')
      subject.should_receive(:to_io).with($stdout, 'operation', '<xml/>')

      subject.generate
    end

    context "output strategies" do
      subject { Soap::Client::Template::Generator.new @xml_generator_mock, converter: XmlToBuilderXmlConverter.new }

      it "default, :to_io should print to $stdout" do
        @xml_generator_mock.stub(:each).and_yield('getFirstName', read_fixture_with_underscored_name('get_first_name.xml'))

        subject.generate
        $stdout.string.should eql read_fixture_with_underscored_name('get_first_name.xml.builder.stdout')
      end

      it ":to_io with output param should print to this output" do
        @xml_generator_mock.stub(:each).and_yield('getFirstName', read_fixture_with_underscored_name('get_first_name.xml'))

        out = StringIO.new
        subject.generate :to_io, out
        out.string.should eql read_fixture_with_underscored_name('get_first_name.xml.builder.stdout')
      end

      it ":to_file strategy should create file" do
        @xml_generator_mock.stub(:each).and_yield('getFirstName', read_fixture_with_underscored_name('get_first_name.xml'))

        subject.generate :to_file, dir: @dir, ext: 'xml.builder'

        File.read(File.join(@dir,'get_first_name.xml.builder')).should eql read_fixture_with_underscored_name('get_first_name.xml.builder')
      end
    end

  end

end