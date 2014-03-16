class User
  include BasicModel
  #RObject should be handled only in models, controller must see only Ruby object

  attribute :id
  attribute :name
  attribute :email
  attribute :password


  validates :email, presence: true

  #TODO all this method can/must be moved into BasicModel
  def store
    client = riak_client
    self.id ||= give_uuid
    user = client[self.class.name.downcase.pluralize].get_or_new(self.id)
    user.data = self.attributes
    user.indexes['email_bin'] << self.email
    user.indexes['joined_int'] << Time.now.utc.to_i
    user.store
  end

  def save
    valid? ? store : false
  end

  def self.all
    client = riak_client
    bucket = client[self.name.downcase.pluralize]
    users = bucket.get_index('joined_int', 0..Time.now.utc.to_i)
    users.map { |u| parse_from_riak(bucket[u]) }
  end


  def self.parse_from_riak(rkobject)
    new(rkobject.data)
  end

end