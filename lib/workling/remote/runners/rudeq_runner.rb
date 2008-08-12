require 'workling/remote/runners/base'

module Workling
  module Remote
    module Runners
      class RudeqRunner < Workling::Remote::Runners::Base
        cattr_accessor :routing
        cattr_accessor :client
        
        def initialize
          RudeqRunner.client = Workling::Rudeq::Client.new
          RudeqRunner.routing = Workling::Starling::Routing::ClassAndMethodRouting.new
        end
        
        def run(clazz, method, options = {})
          RudeqRunner.client.set(@@routing.queue_for(clazz, method), options)
          
          return nil # empty.
        end
      end
    end
  end
end