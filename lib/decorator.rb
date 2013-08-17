module Decorator
  def initialize(object)
    @object = object
  end

  def method_missing(meth, *args)
    if object.respond_to?(meth)
      object.send(meth, *args)
    else
      super
    end
  end

  def respond_to?(meth)
    object.respond_to?(meth)
  end

  def class
    object.class
  end

  private

  attr_accessor :object
end
