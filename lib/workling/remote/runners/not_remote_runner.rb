require 'workling/remote/runners/base'

module Workling
  module Remote
    module Runners
      class NotRemoteRunner < Workling::Remote::Runners::Base
        def run(clazz, method, options = {})
          options = Marshal.load(Marshal.dump(options)) # get this to behave more like the remote runners
          dispatch!(clazz, method, options) 
          
          return nil # nada. niente.
        end
      end
    end
  end
end
