require 'workling/rudeq'

module Workling
  module Rudeq
    class Client
      attr_reader :queue
      
      def initialize 
        @queue = Workling::Rudeq.config[:queue_class].constantize
      end
      
      def method_missing(method, *args)
        @queue.send(method, *args)
      end
    end
  end
end