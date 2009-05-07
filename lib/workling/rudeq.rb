module Workling
  module Rudeq
    def self.config
      @@config ||=  {:queue_class => "RudeQueue"}
    end    
  end
end