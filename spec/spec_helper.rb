require 'simplecov'
SimpleCov.start

ENV['APP_ENVIRONMENT'] ||= 'test'

require_relative '../app/application'

if Application.production?
  abort('The environment is running in production mode!')
end

require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.profile_examples = 3
end
