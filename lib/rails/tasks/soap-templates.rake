require "soap-client-template"

namespace :soap do
  desc "Generate template for soap response. wsdl - full path to wsdl"
  task :generate, :wsdl, :xsd, :dir, :operation do |_, args|
    Soap::Client::Template.generate(args.wsdl, args.xsd, args.dir, args.operation)
  end
end