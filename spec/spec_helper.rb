ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rspec/rails'
require 'devise'
require 'database_cleaner/active_record'

# Add additional requires below this line. Rails is not loaded until this point!

# Configuração para Devise
RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request

  # Database Cleaner
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Outros códigos de configuração
end
