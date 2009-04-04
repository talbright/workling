require 'workling/remote/runners/base'

#
# this does absolutely nothing, mainly for testing
#

module Workling
  module Remote
    module Runners
      class NotRunner < Workling::Remote::Runners::Base
        def run(clazz, method, options = {})
          return nil # nada. niente.
        end
      end
    end
  end
end
