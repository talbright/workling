require File.dirname(__FILE__) + '/test_helper.rb'

context "the RudeQ poller" do
  setup do
    routing = Workling::Starling::Routing::ClassAndMethodRouting.new
    @client = Workling::Rudeq::Poller.new(routing)
  end
  
  specify "should invoke Util.echo with the arg 'hello' if the string 'hello' is set onto the queue utils__echo" do
    Util.any_instance.expects(:echo).with("hello")
    RudeQueue.set("utils__echo", "hello")
    @client.dispatch!(RudeQueue, Util)
  end
end