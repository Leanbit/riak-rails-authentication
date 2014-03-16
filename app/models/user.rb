class User
  include BasicModel
  INDEX = ['email_bin', 'joined_int']

  #Doesn't make a lot of sense for range index but only for string/bin index
  INDEX.each do |index|
    define_singleton_method :"find_by_#{index.split('_').first}" do |value|
      bucket = riak_client[self.name.downcase.pluralize]
      bucket.get_index(index, value).map { |u| parse_from_riak(bucket[u]) }.first
    end
  end
  
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
    #TODO it would be nice/necessary to pass a block to configure the bucket property before store
    user.store
  end

  def save
    valid? ? store : false
  end

  def destroy
    bucket = riak_client[self.name.downcase.pluralize]
    user = bucket.exist?(id) ? parse_from_riak(bucket[id]) : nil
    user ? user.delete : nil
  end

  def authenticate(password)
    #DO NOT USE IN PRODUCTION
    password == self.password
  end

  #Class Methods
  class << self
    def all(parse = true)
      client = riak_client
      bucket = client[self.name.downcase.pluralize]
      users = bucket.get_index('joined_int', 0..Time.now.utc.to_i)
      parse ? users.map { |u| parse_from_riak(bucket[u]) } : users
    end

    #RObject should be handled only in models, controller must see only Ruby object
    def parse_from_riak(rkobject)
      new(rkobject.data)
    end

    def find_by_id(id)
      bucket = riak_client[self.name.downcase.pluralize]
      bucket.exist?(id) ? parse_from_riak(bucket[id]) : nil
    end
  end

end