require 'workling/return/store/base'
require 'workling/rudeq/client'

module Workling
  module Return
    module Store
      class RudeqReturnStore < Base
        cattr_accessor :client
        
        def initialize
          self.class.client = Workling::Rudeq::Client.new
        end
        
        def set(key, value)
          self.class.client.set(key, value)
        end
        
        def get(key)
          self.class.client.get(key)
        end
      end
    end
  end
end