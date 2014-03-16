module RiakClient
  extend ActiveSupport::Concern
  def riak_client
    database_config = Settings.database
    Riak::Client.new( database_config.to_hash.each { |k,v|  database_config[k] = v.map(&:to_hash) if v.is_a? Array }.to_hash )
  end

  def give_uuid
    UUID.state_file = false
    UUID.generator.next_sequence
    UUID.new.generate(:compact)
  end
end
Object.send(:include, RiakClient)
