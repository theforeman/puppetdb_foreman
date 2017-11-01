# Tests
namespace :test do
  desc 'Test PuppetdbForeman'
  Rake::TestTask.new(:puppetdb_foreman) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :puppetdb_foreman do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_puppetdb_foreman) do |task|
        task.patterns = ["#{PuppetdbForeman::Engine.root}/app/**/*.rb",
                         "#{PuppetdbForeman::Engine.root}/lib/**/*.rb",
                         "#{PuppetdbForeman::Engine.root}/test/**/*.rb"]
      end
    rescue StandardError
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_puppetdb_foreman'].invoke
  end
end

Rake::Task[:test].enhance ['test:puppetdb_foreman']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:puppetdb_foreman', 'puppetdb_foreman:rubocop']
end
