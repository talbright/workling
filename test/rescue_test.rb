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

  specify "should call on_error method" do 
    count = Util.on_error_call_count
    Workling::Remote.run(:util, :broken)

    Util.on_error_call_count.should.equal(count + 1)
  end
end
