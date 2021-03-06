# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dota_steam/version'

Gem::Specification.new do |spec|
  spec.name          = 'dota_steam'
  spec.version       = DotaSteam::VERSION
  spec.authors       = ['sebyx07']
  spec.email         = ['gore.sebyx@yahoo.com']

  spec.summary       = %q{ omg lol }
  spec.description   = %q{ omg lol }
  spec.homepage      = 'http://guides.rubygems.org/'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = Dir['README', 'lib/**/*']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'http', '~> 0.9.0'
  spec.add_dependency 'multi_json', '~> 1.11.2'
  spec.add_dependency 'configurations', '~> 2.2.0'


  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'webmock', '~> 1.21.0'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-nc'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-remote'
  spec.add_development_dependency 'pry-nav'
end
