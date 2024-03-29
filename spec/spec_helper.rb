require 'simplecov'
SimpleCov.add_filter 'spec'
SimpleCov.add_filter 'config'
SimpleCov.start

$:.unshift(File.dirname(File.dirname(__FILE__)))

ENV["RACK_ENV"] = "test"
require 'config/environment'

require 'rack/test'
require 'config/logging'

set :environment, :test

# Run all examples in a transaction
RSpec.configure do |c|
  c.around(:each) do |example|
    ActiveRecord::Base.connection.transaction do
      example.run 
      raise ActiveRecord::Rollback
    end
  end
end
