# Be sure to restart your server when you modify this file.

# RiakRailsAuthentication::Application.config.session_store :cookie_store, key: '_riak-rails-authentication_session'

nodes_count = Settings.database.nodes.count
RiakRailsAuthentication::Application.config.session_store :"ripple_session_store", { 
  nodes: Settings.database.nodes.map(&:to_hash), 
  n_val: nodes_count, 
  r: nodes_count - 1,
  w: nodes_count - 1,
  rw: nodes_count - 1,
  dw: nodes_count - 1,
  pw: nodes_count - 1,
  # This last two options are set according to riak doc, where this combination make sense in case of session usage 
  # http://docs.basho.com/riak/latest/theory/concepts/Vector-Clocks/
  last_write_wins: true,
  allow_mult: false
}