# encoding: utf-8

require File.expand_path('../lib/srsly/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'srsly'
  gem.version     = Srsly::VERSION
  gem.authors     = [ 'Arne Brasseur' ]
  gem.email       = [ 'arne@arnebrasseur.net' ]
  gem.description = 'Flashcard Srsly with Spaced Repetition.'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/plexus/srsly'
  gem.license     = 'GPL-2'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md]

  gem.add_runtime_dependency 'analects', '~> 0.3.1'

  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rspec', '~> 2.14'
end
