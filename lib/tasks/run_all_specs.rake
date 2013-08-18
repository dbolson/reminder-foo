begin
  require 'rspec/core/rake_task'

  desc 'Run all tests regardless of exclude tags'
  RSpec::Core::RakeTask.new('spec:all') do |task|
    task.pattern = './**/*_spec.rb'
    task.rspec_opts = '-O .rspec-all-tests'
  end

  task default: :fast_spec

rescue LoadError => e
  desc 'Run all tests regardless of exclude tags'
  task :spec_all do
    abort 'spec_all rake task is not available.'
  end
end
