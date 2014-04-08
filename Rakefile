require 'rubygems/package_task'

spec = Gem::Specification.load(File.expand_path('../engine.gemspec', __FILE__))
gem = Gem::PackageTask.new(spec)
gem.define

desc "Push gem to rubygems.org"
task :push => :gem do
  sh "git tag v#{Engine::VERSION}"
  sh "git push --tags"
  sh "gem push pkg/engine-#{Engine::VERSION}.gem"
end
