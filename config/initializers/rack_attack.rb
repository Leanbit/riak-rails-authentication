Rack::Attack.throttle('sessions', :limit => 6, :period => 60.seconds) do |req|
  req.params['email'] if req.path == '/sessions.json' && req.post?
end

Rack::Attack.blacklisted_response = lambda do |env|
  # Using 503 because it may make attacker think that they have successfully
  # DOSed the site. Rack::Attack returns 403 for blacklists by default
  [ 503, {}, ['Blocked']]
end

Rack::Attack.throttled_response = lambda do |env|
  # name and other data about the matched throttle
  body = [
    env['rack.attack.matched'],
    env['rack.attack.match_type'],
    env['rack.attack.match_data']
  ].inspect

  # Using 503 because it may make attacker think that they have successfully
  # DOSed the site. Rack::Attack returns 429 for throttling by default
  [ 503, {}, [body]]
end

# ab -n 100 -c 1 -p post_data -T 'application/x-www-form-urlencoded' http://localhost:9292/sessions
