require 'workling/base'

class Util < Workling::Base
  def echo(*args)
    # shout!
  end
  
  def faulty(args)
    raise Exception.new("this is pretty faulty.")
  end
  
  def stuffing(contents)
    # expects contents. 
  end

  expose :very_open, :as => "my very_own queue"
  def very_open(chocolate)
    
  end
end
