require 'bundler/setup'
require 'design_by_contract'
require 'logger'
require 'pp'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    DesignByContract.forget_contract_specifications!
    DesignByContract.enable_defensive_contract
  end
end

Dir.glob(File.join(__dir__, 'support', '**', '*.rb')).each { |path| require(path) }
