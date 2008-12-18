require File.dirname(__FILE__) + '/test_helper.rb'

context "the invoker 'thread pool poller'" do
  setup do
    @routing = Workling::Routing::ClassAndMethodRouting.new
    @client = Workling::Clients::MemoryQueueClient.new
    @client.connect
    @invoker = Workling::Remote::Invokers::ThreadPoolPoller.new(@routing, @client.class)
  end

  specify "should have default values for various settings" do
    @invoker.sleep_time.should.equal 2.0
    @invoker.reset_time.should.equal 30.0
    @invoker.pool_capacity.should.equal 25
  end

  specify "should pull configuration values from the workling global config" do
    Workling.stubs(:config).returns(
      :sleep_time => 10, :reset_time => '45', :pool_size  => '50'
    )

    @invoker = Workling::Remote::Invokers::ThreadPoolPoller.new(@routing, @client.class)

    @invoker.sleep_time.should.equal 10.0
    @invoker.reset_time.should.equal 45.0
    @invoker.pool_capacity.should.equal 50
  end

  specify "should work in general" do
    # Assumptions
    Workling::Discovery.discovered.size.should.not.be 0

    client = mock()
    client.stubs(:connect)
    client.expects(:retrieve).at_least_once.returns(nil)
    @client.class.expects(:new).times(Workling::Discovery.discovered.size).returns(client)

    Timeout.timeout(10) do
      listener = Thread.new { @invoker.listen }

      # Wait until the invoker has finished starting
      while(@invoker.poller_threads != Workling::Discovery.discovered.size)
        Thread.pass
      end

      @invoker.stop
      listener.join
    end
  end
end
