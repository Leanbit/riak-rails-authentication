class Connection
  extend ActiveModel::Naming
  
  attr_accessor :client

  def initialize(attributes={})
    database_config = Settings.database
    self.client =  Riak::Client.new( database_config.to_hash.each { |k,v|  database_config[k] = v.map(&:to_hash) if v.is_a? Array }.to_hash )
  end
end