
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_record_temptable/version"

Gem::Specification.new do |spec|
  spec.name          = "active_record_temptable"
  spec.version       = ActiveRecordTemptable::VERSION
  spec.authors       = ["Marcin Henryk Bartkowiak"]
  spec.email         = ["mhbartkowiak@gmail.com"]
  spec.licenses      = ["MIT"]

  spec.summary       = 'Temp Table for activerecord'
  spec.homepage      = "https://github.com/railwaymen/active_record_temptable"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'activerecord', '>= 4.2.3'

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'pg', '~> 0.18.4'
  spec.add_development_dependency 'mysql2', '~> 0.4.1'
end
