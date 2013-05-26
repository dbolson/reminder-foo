if @object.errors.any?
  node :errors do
    @object.errors.full_messages
  end
end
