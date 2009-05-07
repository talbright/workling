require File.dirname(__FILE__) + '/test_helper'

context "The Rudeq client" do
  specify "should by default set a RudeQueue as its :queue" do
    client = Workling::Rudeq::Client.new
    client.queue.should == RudeQueue
  end
  
  specify "should user Rudeq.config[:queue_class] as the class" do
    before = Workling::Rudeq.config[:queue_class]
    
    Workling::Rudeq.config[:queue_class] = "String"
    client = Workling::Rudeq::Client.new
    client.queue.should == String
    
    Workling::Rudeq.config[:queue_class] = before
  end

  specify "should defer :get to the RudeQueue" do
    RudeQueue.expects(:get).with(:abc)
    client = Workling::Rudeq::Client.new
    client.get(:abc)
  end
  
  specify "should defer :set to the RudeQueue" do
    RudeQueue.expects(:set).with(:abc, "some value")
    client = Workling::Rudeq::Client.new
    client.set(:abc, "some value")
  end
end