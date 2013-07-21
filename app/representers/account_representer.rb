module AccountRepresenter
  include BaseRepresenter

  property :id
  property :email
  property :updated_at
  property :created_at

  link :self do
    account_url(env)
  end
end
