ENV['JETS_TEST'] = "1"
ENV['JETS_ENV'] ||= "test"
# Ensures aws api never called. Fixture home folder does not contain ~/.aws/credentails
ENV['HOME'] = "spec/fixtures/home"

require "byebug"
require "fileutils"
require "jets"
require 'database_cleaner'

abort("The Jets environment is running in production mode!") if Jets.env == "production"
Jets.boot

require "jets/spec_helpers"

module Helpers
  def payload(name)
    JSON.load(IO.read("spec/fixtures/payloads/#{name}.json"))
  end

  def json_response
    JSON.parse(response.body)
  end

  def json_body_response
    JSON.parse(response_body).deep_symbolize_keys
  end

  def get_auth_token(user_id)
    JsonWebToken.encode(user_id: user_id)
  end
end

DatabaseCleaner.allow_remote_database_url = true

RSpec.configure do |c|
  c.include Helpers
  c.include FactoryBot::Syntax::Methods

  c.before(:suite) do
    FactoryBot.find_definitions
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  c.around(:each) do |example|
    DatabaseCleaner.cleaning(&example)
  end
end

RspecApiDocumentation.configure do |config|
  config.format = :open_api
  config.app = Jets.application
  config.request_body_formatter = :json
end
