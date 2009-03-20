require 'eventmachine'
require 'workling/remote/invokers/base'

#
# TODO - Subscribes a single worker to a single queue 
# 
module Workling
  module Remote
    module Invokers
      class AmqpSingleSubscriber < Workling::Remote::Invokers::Base
        
        def initialize(routing, client_class)
          super
        end
        
        #
        # TODO - how to configure the queue name?
        #  Starts EM loop and sets up subscription callbacks for workers. 
        #
        def listen
          EM.run do
            connect do
              queue_name = "out.queue"

              # temp stuff to hook the queues and exchanges up
              # wildcard routing
              exch = MQ.topic
              q = MQ.queue(queue_name)
              q.bind(exch, :key => "*")

              @client.subscribe(queue_name) do |args|
                run(queue_name, args)
              end
            end
          end
        end
                
        def stop
          EM.stop if EM.reactor_running?
        end
      end
    end
  end
end