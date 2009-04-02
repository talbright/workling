require 'workling/clients/base'
Workling.try_load_an_amqp_client

#
#  An Ampq client
#
module Workling
  module Clients
    class AmqpExchangeClient < Workling::Clients::Base
      
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
        @amq.queue(key).subscribe do |header, body|

          puts "***** received msg with header - #{header.inspect}"

          value = YAML.load(body)
          yield value
        end
      end
      
      # request and retrieve work
      def retrieve(key)
          @amq.queue(key)
      end

      # publish message to exchange
      # using the specified routing key
      def request(exchange_name, value)
        key = value.delete(:routing_key)
        msg = YAML.dump(value)
        exchange = @amq.topic(exchange_name)
        exchange.publish(msg, :routing_key => key, :x-custom_header => "this is a test")
      end
    end
  end
end
