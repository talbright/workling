require File.dirname(__FILE__) + '/test_helper.rb'

context "the RudeQ runner" do
  setup do
    @before = Workling::Remote.dispatcher
  end
  
  specify "should set up a RudeQ client" do
    Workling::Remote.dispatcher = Workling::Remote::Runners::RudeqRunner.new
    Workling::Remote.dispatcher.client.should.not.equal nil
    Workling::Remote.dispatcher.client.queue.should.equal RudeQueue
  end

  specify ":run should use Starling routing" do
    RudeQueue.expects(:set).with("utils__echo", "hello")
    Workling::Remote::Runners::RudeqRunner.new.run(Util, :echo, "hello")
  end
  
  teardown do
    Workling::Remote.dispatcher = @before
  end
end