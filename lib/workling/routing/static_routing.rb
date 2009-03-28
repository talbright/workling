require 'workling/routing/base'

#
#  Holds a single route for a dedicated worker (if you want more worker processes, run more workers)
#
module Workling
  module Routing
    class StaticRouting

      # ./script/workling_client run -- <worker_class> <worker_method> <routing_key>      
      # ./script/workling_client run -- CowWorker moo "#"
      # the queue name for this example would be "cow_workers__moo_#" (<worker_class_tableized>__<worker_method>__<routing_key>)
      def initialize(*args)
        @worker = args[0].constantize.new
        @method_name = args[1]
        @routing_key = args[2]
        @queue_name = [@worker.class.to_s.tableize, @method_name, @routing_key].join("__")

        puts "** static routing: queue - #{@queue_name}, routing_key - #{@routing_key}, method - #{@method_name}, worker - #{@worker.class}"
      end

      # TODO - redo this...
      def [](x)
        @worker
      end

      # returns the worker method name, given the routing string. 
      def method_name(queue=nil)
        @method_name
      end

      def routing_key_for
        @routing_key
      end

      # returns the routing string, given a class and method. delegating.
      # TODO - we can check for consistency here with clazz and methods vs. current configuration of this single route
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