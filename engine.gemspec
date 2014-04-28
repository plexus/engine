# encoding: utf-8

require File.expand_path('../lib/engine/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'engine'
  gem.version     = Engine::VERSION
  gem.authors     = [ 'Arne Brasseur' ]
  gem.email       = [ 'arne@arnebrasseur.net' ]
  gem.description = 'Flashcard Engine with Spaced Repetition.'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/plexus/engine'
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md]

  gem.add_runtime_dependency 'hexp', '~> 0.2.0'

  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'mutant-rspec', '~> 0.5.10'
end
