require 'workling/routing/base'

#
#  Holds a single route
#
module Workling
  module Routing
    class AmqpSingleQueueRouting
          
      def initialize
        @method_name = "moo"
        @worker = nil
        @queue_name = "out.queue"
      end
      
      # returns the worker method name, given the routing string. 
      def method_name(queue)
        @method_name
      end
      
      # returns the routing string, given a class and method. delegating. 
      def queue_for(clazz, method)
        AmqpSingleQueueRouting.queue_for(clazz, method)
      end
              
      # returns the routing string, given a class and method.
      def self.queue_for(clazz, method)
        @queue_name
      end
      
      # returns all routed
      def queue_names
        [@queue_name]
      end
      
      # dare you to remove this! go on!
      # TODO - not sure what this is...
      def queue_names_routing_class(clazz)
        @worker.class
      end         
    end
  end
end