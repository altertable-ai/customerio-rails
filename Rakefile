require 'bundler'
Bundler::GemHelper.install_tasks
require 'rake'

# rubygems/release-gem runs `rake release`, which would otherwise create a
# git tag that release-please already created.
Rake::Task['release'].clear
desc 'Push gem to RubyGems.org without creating a git tag'
task release: 'release:rubygem_push'

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--options', "\"#{File.dirname(__FILE__)}/spec/spec.opts\""]
end

task :default => :spec