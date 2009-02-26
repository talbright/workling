require File.dirname(__FILE__) + '/test_helper'

context "the RudeQ return store" do

  def get_store
    Workling::Return::Store::RudeqReturnStore.new
  end
  
  specify "should defer :get to the RudeQueue" do
    RudeQueue.expects(:get).with(:abc)
    store = get_store
    store.get(:abc)
  end
  
  specify "should defer :set to the RudeQueue" do
    RudeQueue.expects(:set).with(:abc, "some value")
    store = get_store
    store.set(:abc, "some value")
  end
end