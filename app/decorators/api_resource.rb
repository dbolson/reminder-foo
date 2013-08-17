class APIResource
  include Decorator

  def created_at
    object.created_at.to_i.to_s
  end

  def updated_at
    object.updated_at.to_i.to_s
  end
end
