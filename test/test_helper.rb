plugin_test = File.dirname(__FILE__)
plugin_root = File.join plugin_test, '..'
plugin_lib = File.join plugin_root, 'lib'

require 'rubygems'
#require 'active_support'

gem 'activerecord'
require 'active_record'

require 'test/spec'
require 'mocha'
begin; require 'redgreen'; rescue; end

$:.unshift plugin_lib, plugin_test

RAILS_ENV = "test"
RAILS_ROOT = File.dirname(__FILE__) + "/.." # fake the rails root directory.

require "mocks/spawn"
require "mocks/logger"
require "mocks/rude_queue"
require "workling"
require "workling/base"

Workling.try_load_a_memcache_client

require "workling/discovery"
require "workling/routing/class_and_method_routing"
require "workling/remote/invokers/basic_poller"
require "workling/remote/invokers/threaded_poller"
require "workling/remote/invokers/thread_pool_poller"
require "workling/remote/invokers/eventmachine_subscriber"
require "workling/rudeq/poller"
require "workling/remote"
require "workling/remote/runners/not_remote_runner"
require "workling/remote/runners/spawn_runner"
require "workling/remote/runners/rudeq_runner"
require "workling/remote/runners/starling_runner"
require "workling/remote/runners/client_runner"
require "workling/remote/runners/backgroundjob_runner"
require "workling/return/store/memory_return_store"
require "workling/return/store/starling_return_store"
require "workling/return/store/rudeq_return_store"
require "workling/return/store/iterator"
require "mocks/client"
require "clients/memory_queue_client"
require "runners/thread_runner"

# worklings are in here.
Workling.load_path = ["#{ plugin_root }/test/workers"]
Workling::Return::Store.instance = Workling::Return::Store::MemoryReturnStore.new
Workling::Discovery.discover!

# make this behave like production code
Workling.raise_exceptions = false
