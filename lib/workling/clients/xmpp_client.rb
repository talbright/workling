require 'workling/clients/base'
Workling.try_load_xmpp4r

#
#  An XMPP client
#
module Workling
  module Clients
    class XmppClient < Workling::Clients::Base

      # starts the client. 
      def connect
        begin
          @client = Jabber::Client.new Workling.config[:jabber_id]
          @client.connect Workling.config[:jabber_server]
          @client.auth Workling.config[:jabber_password]
          @client.send Jabber::Presence.new.set_type(:available)
          @pubsub = Jabber::PubSub::ServiceHelper.new(@client, Workling.config[:jabber_service])
        rescue
          raise WorklingError.new("couldn't connect to the jabber server")
        end
      end

      # disconnect from the server
      def close
        @client.close
      end

      # subscribe to a queue
      def subscribe(key)
        @pubsub.subscribe_to(key)
        @pubsub.add_event_callback do |event|
          event.payload.each do |e|
            yield e
          end
        end
      end

      # request and retrieve work
      def retrieve(key)
        @pubsub.get_items_from(key, 1)
      end

      def request(key, value)
        @pubsub.publish_item_to(key, value)
      end
    end
  end
end
