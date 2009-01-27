require 'workling/clients/base'
Workling.try_load_an_amqp_client

#
#  An Ampq client
#
module Workling
  module Clients
    class AmqpClient < Workling::Clients::Base
            
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
      
      # Decide which method of marshalling to use:
      def cast_value(value, origin)
        case Workling.config[:ymj]
        when 'marshal'
          @cast_value = origin == :request ? Marshal.dump(value) : Marshal.load(value)
        when 'yaml'
          @cast_value = origin == :request ? YAML.dump(value) : YAML.load(value)
        else 
          @cast_value = origin == :request ? Marshal.dump(value) : Marshal.load(value)
        end
        @cast_value
      end
      
      # subscribe to a queue
      def subscribe(key)
        @amq.queue(key).subscribe do |value|
          yield cast_value(value,:subscribe)
        end
      end
      
      # request and retrieve work
      def retrieve(key); @amq.queue(key); end
      def request(key, value); @amq.queue(key).publish(cast_value(value,:request)); end
    end
  end
end