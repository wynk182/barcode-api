require "bundler/gem_tasks"
require 'rake'
begin
  require 'bundler/setup'
  Bundler::GemHelper.install_tasks
rescue LoadError
  puts 'although not required, bundler is recommended for running the tests'
end
task default: :spec
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)