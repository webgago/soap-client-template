require "bundler/gem_tasks"
require "soap-client-template"

task :generate, :wsdl, :xsd, :dir do |_, args|
  Soap::Client::Template.generate(args.wsdl, args.xsd, args.dir)
end