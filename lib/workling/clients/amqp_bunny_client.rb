#
#  An AMQP client based on the synchrounous Bunny library which
#  is easier to use in many situations
#
module Workling
  module Clients
    class AmqpBunnyClient < Workling::Clients::BrokerBase

      def self.load
        begin
          require 'bunny'
        rescue LoadError => e
          raise WorklingError.new("WORKLING: couldn't find the bunny amqp client")
        end
      end

      # starts the client.
      def connect
        begin
          @bunny = Bunny.new((Workling.config[:amqp_options] ||{}).symbolize_keys)
          @bunny.start
        rescue
          raise WorklingError.new("Couldn't start bunny amqp client, ensure the AMQP server is running.")
        end
      end

      # no need for explicit closing. when the event loop
      # terminates, the connection is closed anyway. 
      def close
        @bunny.stop
        # normal amqp does not require stopping
      end

      # subscribe to a queue
      def subscribe(key)
        @bunny.queue(queue_for(key)).subscribe(:timeout => 30) do |value|
          data = Marshal.load(value) rescue value
          yield data
        end
      end

      # request and retrieve work
      def retrieve(key)
        @bunny.queue(queue_for(key)).pop[:payload]
      end

      def request(key, value)
        data = Marshal.dump(value)
        @bunny.queue(queue_for(key)).publish(data)
      end

      private
        def queue_for(key)
          "#{Workling.config[:prefix]}#{key}"
        end

    end
  end
end
