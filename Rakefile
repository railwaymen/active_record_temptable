require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yaml'

CONFIG = YAML::load(File.open(File.join(__dir__, 'database.yml')))

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task create_dbs: %i[create_pg]

task :create_pg do
  %x( createdb -E UTF8 #{CONFIG['postgres']['database']} )
end

