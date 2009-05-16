$setup_loader.register("spawn") do |s|

  s.dispatcher Workling::Remote::Runners::SpawnRunner

  s.guard do
    Workling::Remote::Runners::SpawnRunner.installed?
  end

end
