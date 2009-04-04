require "workling/remote/runners/not_remote_runner"
require "workling/remote/runners/spawn_runner"
require "workling/remote/runners/starling_runner"
require "workling/remote/runners/backgroundjob_runner"
require "workling/remote/invokers/threaded_poller"

require 'digest/md5'

#
#  Scoping Module for Runners. 
#
module Workling
  module Remote
    
    # set the desired runner here. this is initialized with Workling.default_runner. 
    mattr_accessor :dispatcher

    # set the desired invoker. this class grabs work from the job broker and executes it.
    mattr_accessor :invoker
    @@invoker ||= self.select_invoker

    mattr_accessor :routing
    @@routing ||= Workling::Routing::ClassAndMethodRouting

    # retrieve the dispatcher or instantiate it using the defaults
    def self.dispatcher
      @@dispatcher ||= Workling.default_runner
    end
    
    # generates a unique identifier for this particular job. 
    def self.generate_uid(clazz, method)
      uid = ::Digest::MD5.hexdigest("#{ clazz }:#{ method }:#{ rand(1 << 64) }:#{ Time.now }")
      "#{ clazz.to_s.tableize }/#{ method }/#{ uid }".split("/").join(":")
    end
    
    # dispatches to a workling. writes the :uid for this work into the options hash, so make 
    # sure you pass in a hash if you want write to a return store in your workling.
    def self.run(clazz, method, options = {})
      uid = Workling::Remote.generate_uid(clazz, method)
      options[:uid] = uid if options.kind_of?(Hash) && !options[:uid]
      Workling.find(clazz, method) # this line raises a WorklingError if the method does not exist. 
      dispatcher.run(clazz, method, options)
      uid
    end

    private

    # Select which invoke to load based on what is defined in workling.yml. Defaults to thread_poller
    # if none are specified.
    def self.select_invoker
      case(Workling.config[:invoker])
      when 'basic_poller'
        require 'workling/remote/invokers/basic_poller'
        Workling::Remote::Invokers::BasicPoller

      when 'thread_pool_poller'
        require 'workling/remote/invokers/thread_pool_poller'
        Workling::Remote::Invokers::ThreadPoolPoller

      when 'eventmachine_subscriber'
        require 'workling/remote/invokers/eventmachine_subscriber'
        Workling::Remote::Invokers::EventmachineSubscriber

      when 'threaded_poller', nil
        require 'workling/remote/invokers/threaded_poller'
        Workling::Remote::Invokers::ThreadedPoller

      else
        require 'workling/remote/invokers/threaded_poller'
        Workling.logger.error("Nothing is known about #{Workling.config[:invoker]} defaulting to thread_poller")
        Workling::Remote::Invokers::ThreadedPoller
      end
    end

  end
end
