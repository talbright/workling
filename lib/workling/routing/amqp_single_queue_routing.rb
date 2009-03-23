require 'workling/routing/base'

#
#  Holds a single route
#
module Workling
  module Routing
    class AmqpSingleQueueRouting

      # CowWorker moo out.queue #
      def initialize
        @worker = ARGV[0].constantize.new
        @method_name = ARGV[1]
        @routing_key = ARGV[2]
        @queue_name = [@worker.class.to_s.tableize, @method_name, @routing_key].join("__")

        puts "** single queue routing: queue - #{@queue_name}, routing_key - #{@routing_key}, method - #{@method_name}, worker - #{@worker.class}"
      end

      # TODO - redo this...
      def [](x)
        @worker
      end

      # returns the worker method name, given the routing string. 
      def method_name(queue)
        @method_name
      end

      def routing_key_for
        @routing_key
      end

      # returns the routing string, given a class and method. delegating. 
      def queue_for(clazz=nil, method=nil)
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