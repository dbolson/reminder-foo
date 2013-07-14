namespace :sandbox do
  desc 'populate the sandbox environment'
  task populate: :environment do
    Services::Sandbox.populate!
  end
end
