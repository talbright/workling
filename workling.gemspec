# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{workling}
  s.version = "0.4.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rany Keddo"]
  s.date = %q{2009-02-25}
  s.description = %q{easily do background work in rails, without commiting to a particular runner. comes with starling, bj and spawn runners.}
  s.email = %q{nicolas@marchildon.net}
  s.files = ["CHANGES.markdown",
             "VERSION.yml",
             "README.markdown",
             "TODO.markdown",
             "lib/cattr_accessor.rb",
             "lib/mattr_accessor.rb",
             "lib/rude_q/client.rb",
             "lib/workling/base.rb",
             "lib/workling/clients/amqp_client.rb",
             "lib/workling/clients/amqp_exchange_client.rb",
             "lib/workling/clients/base.rb",
             "lib/workling/clients/memcache_queue_client.rb",
             "lib/workling/clients/sqs_client.rb",
             "lib/workling/clients/xmpp_client.rb",
             "lib/workling/discovery.rb",
             "lib/workling/remote/invokers/amqp_single_subscriber.rb",
             "lib/workling/remote/invokers/base.rb",
             "lib/workling/remote/invokers/basic_poller.rb",
             "lib/workling/remote/invokers/eventmachine_subscriber.rb",
             "lib/workling/remote/invokers/looped_subscriber.rb",
             "lib/workling/remote/invokers/thread_pool_poller.rb",
             "lib/workling/remote/invokers/threaded_poller.rb",
             "lib/workling/remote/runners/amqp_exchange_runner.rb",
             "lib/workling/remote/runners/backgroundjob_runner.rb",
             "lib/workling/remote/runners/base.rb",
             "lib/workling/remote/runners/client_runner.rb",
             "lib/workling/remote/runners/not_remote_runner.rb",
             "lib/workling/remote/runners/not_runner.rb",
             "lib/workling/remote/runners/rudeq_runner.rb",
             "lib/workling/remote/runners/spawn_runner.rb",
             "lib/workling/remote/runners/starling_runner.rb",
             "lib/workling/remote.rb",
             "lib/workling/return/store/base.rb",
             "lib/workling/return/store/iterator.rb",
             "lib/workling/return/store/memory_return_store.rb",
             "lib/workling/return/store/rudeq_return_store.rb",
             "lib/workling/return/store/starling_return_store.rb",
             "lib/workling/routing/base.rb",
             "lib/workling/routing/class_and_method_routing.rb",
             "lib/workling/routing/static_routing.rb",
             "lib/workling/rudeq/client.rb",
             "lib/workling/rudeq/poller.rb",
             "lib/workling/rudeq.rb",
             "lib/workling.rb",
             "lib/workling_server.rb",
             "script/bj_invoker.rb",
             "script/starling_status.rb"].flatten
  s.executables = ["workling_client"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/elecnix/workling}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{easily do background work in rails, without commiting to a particular runner. comes with starling, bj and spawn runners.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
