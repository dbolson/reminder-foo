begin
  require 'rspec/core/rake_task'

  desc 'Run all tests regardless of tags'
  RSpec::Core::RakeTask.new('spec:all') do |task|
    task.pattern = './**/*_spec.rb'
    task.rspec_opts = '-O .rspec-no-tags'
  end

rescue LoadError => e
  desc 'Run all tests regardless of tags'
  task 'spec:all' do
    abort 'spec:all rake task is not available.'
  end
end
