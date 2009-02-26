require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the loopy_workling plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the loopy_workling plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'LoopyWorkling'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "workling"
    s.summary = "easily do background work in rails, without commiting to a particular runner. comes with starling, bj and spawn runners."
    s.email = "nicolas@marchildon.net"
    s.homepage = "http://github.com/elecnix/workling"
    s.description = "easily do background work in rails, without commiting to a particular runner. comes with starling, bj and spawn runners."
    s.authors = ["Rany Keddo"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

