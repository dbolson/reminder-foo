begin
  require 'rspec/core/rake_task'

  desc 'Run fast specs'
  RSpec::Core::RakeTask.new('spec:fast') do |task|
    task.pattern = 'spec_fast/**/*_spec.rb'
    task.rspec_opts = '-Ispec_fast'
  end

  task spec: 'spec:fast'

rescue LoadError => e
  desc 'Run fast specs'
  task 'spec:fast' do
    abort 'Fast specs rake task is not available.'
  end
end
