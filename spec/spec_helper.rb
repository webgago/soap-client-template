# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper.rb"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

CURRENT_DIR=File.dirname(__FILE__)
$: << File.expand_path("../lib")

require "soap-client-template"
require "wsdl"

module FixtureAccess
  def read_fixture_with_underscored_name(filename)
    File.read('spec/fixtures/' + File.basename(filename).underscore)
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.include FixtureAccess
end