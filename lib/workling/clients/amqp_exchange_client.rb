require 'workling/clients/base'
Workling.try_load_an_amqp_client

#
#  An Ampq client
#
module Workling
  module Clients
    class AmqpTopicClient < Workling::Clients::Base
      
      # starts the client. 
      def connect
        begin
          @amq = MQ.new
        rescue
          raise WorklingError.new("couldn't start amq client. if you're running this in a server environment, then make sure the server is evented (ie use thin or evented mongrel, not normal mongrel.)")
        end
      end
      
      # no need for explicit closing. when the event loop
      # terminates, the connection is closed anyway. 
      def close; true; end
      
      # subscribe to a queue
      def subscribe(key)
        @amq.queue(key).subscribe do |data|
          value = YAML.load(data)
          yield value
        end
      end
      
      # request and retrieve work
      def retrieve(key)
          @amq.queue(key)
      end

      # publish message to amq.topic exchange
      # using the specified routing key
      def request(key, value)
        data = YAML.dump(value)
        exchange = @amq.topic
        exchange.publish(data, :routing_key => key)
      end
    end
  end
end
