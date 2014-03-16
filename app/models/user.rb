class User
  include BasicModel
  #RObject should be handled only in models, controller must see only Ruby object

  attribute :id
  attribute :name
  attribute :email
  attribute :password


  validates :email, presence: true

  def store
    client = riak_client
    self.id ||= give_uuid
    user = client[self.class.name.downcase.pluralize].get_or_new(self.id)
    user.data = self.attributes
    user.store
  end

  def save
    valid? ? store : false
  end


  def parse_from_riak
  end

end