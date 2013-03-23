require "bundler/gem_tasks"

desc 'Default: run unit tests.'
task default: :test

require 'rake/testtask'
desc 'Test the Thesis gem.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
