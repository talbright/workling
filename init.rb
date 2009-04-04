# in order to allow more control over the load_path the initialization 
# is done explicitly in the workling_client
unless WorklingServer.in_server_mode
  Workling.try_load_a_memcache_client
  Workling::Discovery.discover!
  Workling.config
end
