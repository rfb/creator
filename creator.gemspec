# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','creator','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'creator'
  s.version = Creator::VERSION
  s.author = 'Ryan Barber'
  s.email = 'ryan@5stone.io'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Interface with Zoho Creator apps'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.extra_rdoc_files = ['README.rdoc','creator.rdoc']
  s.rdoc_options << '--title' << 'creator' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'creator'
  s.add_development_dependency('rake','~> 0.9.2')
  s.add_development_dependency('rdoc', '~> 4.3')
  s.add_development_dependency('minitest', '~> 5.14')
  s.add_runtime_dependency('gli','~> 2.20.1')
  s.add_runtime_dependency('faraday','~> 1.8')
  s.add_runtime_dependency('faraday_middleware','~> 1.2')
  s.add_runtime_dependency('addressable','~> 2.8')
end
