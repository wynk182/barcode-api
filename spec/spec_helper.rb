ENV['RAILS_ENV'] = 'test'
require_relative '../spec/dummy/config/environment'

require 'rspec/rails'
require 'dotenv/load'
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter 'spec/'
  add_filter '.github/'
  add_filter 'lib/generators/templates/'
  add_filter 'lib/encoded/version'
end
if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

ENV['RAILS_ROOT'] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"