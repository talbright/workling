$setup_loader.register("simple starling") do |s|

  s.run_daemon
  s.client Workling::Clients::MemcacheQueueClient
  s.invoker Workling::Remote::Invokers::BasicPoller

  s.config do
    { :listens_on => "localhost:22122" }
  end

  s.guard do
    Workling::Clients::MemcacheQueueClient.installed?
  end

  s.setup_each do
    `starling -P #{s.tmp_directory}/starling.pid -d`
  end

  s.teardown_each do
    `kill #{File.read("#{s.tmp_directory}/starling.pid")}`
  end

end
