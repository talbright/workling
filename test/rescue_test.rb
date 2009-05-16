require File.dirname(__FILE__) + '/test_helper.rb'

context "Exceptions raised by worker" do
  before do    
    @old_dispatcher = Workling::Remote.dispatcher
    Workling::Remote.dispatcher = Workling::Remote::Runners::NotRemoteRunner.new
  end
  after do
    Workling::Remote.dispatcher = @old_dispatcher # set back to whence we came
  end
  
  specify "should not escape dispatcher" do
    lambda {
      Workling::Remote.run(:util, :broken)
    }.should.not.raise
  end

  specify "should call notify_exception method" do 
    Util.any_instance.expects(:notify_exception).once
    Workling::Remote.run(:util, :broken)
  end
end
