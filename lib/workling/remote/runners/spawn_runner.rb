require 'workling/remote/runners/base'

module Workling
  module Remote
    module Runners
      class SpawnRunner < Workling::Remote::Runners::Base
        cattr_accessor :options
        @@options = { :method => :fork }
        include Spawn if Workling.spawn_installed?
        
        def run(clazz, method, options = {})
          spawn(SpawnRunner.options) do # exceptions are trapped in here. 
            dispatch!(clazz, method, options)
          end
          
          return nil # that means nothing!
        end
      end
    end
  end
end