require 'figaro'

module Figaro
  extend self

  def path
    @path ||= "#{Dir.pwd}/config/application.yml"
  end

  def environment
    'test'
  end
end
ENV.update(Figaro.env)
