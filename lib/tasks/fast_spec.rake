begin
  require 'rspec/core/rake_task'

  desc 'Run fast specs'
  RSpec::Core::RakeTask.new(:fast_spec) do |task|
    task.pattern = 'spec_fast/**/*_spec.rb'
    task.rspec_opts = '-Ispec_fast'
  end

  task default: :fast_spec

rescue LoadError => e
  desc 'Run fast specs'
  task :fast_spec do
    abort 'Fast specs rake task is not available.'
  end
end
