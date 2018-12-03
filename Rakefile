require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'yaml'

CONFIG = YAML::load(File.open(File.join(__dir__, 'database.yml')))

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task create_dbs: %w[pg:build mysql:build]

namespace :pg do
  task :build do
    %x( createdb -E UTF8 #{CONFIG['postgres']['database']} )
  end
end

namespace :mysql do
  task :build do
    %x( mysql -e "create DATABASE #{CONFIG["mysql"]["database"]} DEFAULT CHARACTER SET utf8mb4" )
  end
end
