module Workling
  module Remote
    module Runners
      class Base
        
        # default logger defined in Workling::Base.logger
        def logger
          Workling::Base.logger
        end

        # find the worker instance and invoke it. 
        def dispatch!(clazz, method, options)
          Workling.find(clazz, method).dispatch_to_worker_method(method, options)
        end
      end
    end
  end
end
