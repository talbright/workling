require File.dirname(__FILE__) + '/../test_helper'

require "workling_server"

class MyClient < Workling::Clients::Base; end;
class MyInvoker < Workling::Remote::Invokers::Base
  attr_reader :router, :client_class
  def initialize(router, client_class)
    @router = router
    @client_class = client_class
  end
end
class MyRouting < Workling::Routing::Base; end;

context "splitting between daemon and workling options" do
  specify "it should split the args array at the separator" do
    WorklingServer.partition_options(["start", "--", "--environment=production"]).should == [["start"], ["--environment=production"]]
  end

  specify "it should only return daemon options if they only exist" do
    WorklingServer.partition_options(["start"]).should == [["start"], []]
  end

  specify "it should only return workling options if they only exist" do
    WorklingServer.partition_options(["--", "--environment=production"]).should == [[], ["--environment=production"]]
  end
end

context "parsing daemon options" do
  specify "should parse -a option" do
    WorklingServer.parse_daemon_options(["-a", "my_app_name"]).should == {:app_name => "my_app_name", :ARGV => []}
  end

  specify "should parse --app_name option" do
    WorklingServer.parse_daemon_options(["--app-name=my_app_name"]).should == {:app_name => "my_app_name", :ARGV => []}
  end

  specify "should parse -m option" do
    WorklingServer.parse_daemon_options(["-m"]).should == {:monitor => true, :ARGV => []}
  end

  specify "should parse --monitor option" do
    WorklingServer.parse_daemon_options(["--monitor"]).should == {:monitor => true, :ARGV => []}
  end

  specify "should pass through start, stop, restart, run, zap commands" do
    %W{start stop restart run zap}.each do |command|
      WorklingServer.parse_daemon_options([command]).should == {:ARGV => [command]}
    end
  end

  specify "should passthrough the -t, --ontop, -f, --force, -h, --help and --version options" do
    %W{-t --ontop -f --force -h --help --version}.each do |option|
      WorklingServer.parse_daemon_options([option]).should == {:ARGV => [option]}
    end
  end


  specify "should parse a command line including both Daemons options and custom daemon_options" do
    WorklingServer.parse_daemon_options(["start", "-t", "-a", "my_app_name"]).should == {:ARGV => ["start", "-t"], :app_name => "my_app_name"}
  end


  specify "should ignore workling options" do
    WorklingServer.parse_daemon_options(["start", "--", "--environment=production"]).should == {:ARGV => ["start"]}
  end
end

context "parsing workling options" do
  specify "should parse the -c option" do
    WorklingServer.parse_workling_options(["--", "-c", "Workling::Clients::MemcacheQueueClient"]).should == {:client_class => "Workling::Clients::MemcacheQueueClient"}
  end

  specify "should parse the --client option" do
    WorklingServer.parse_workling_options(["--", "--client=Workling::Clients::MemcacheQueueClient"]).should == {:client_class => "Workling::Clients::MemcacheQueueClient"}
  end


  specify "should parse the -i option" do
    WorklingServer.parse_workling_options(["--", "-i", "Workling::Remote::Invokers::LoopedSubscriber"]).should == {:invoker_class => "Workling::Remote::Invokers::LoopedSubscriber"}
  end

  specify "should parse the --invoker option" do
    WorklingServer.parse_workling_options(["--", "--invoker=Workling::Remote::Invokers::LoopedSubscriber"]).should == {:invoker_class => "Workling::Remote::Invokers::LoopedSubscriber"}
  end


  specify "should parse the -r option" do
    WorklingServer.parse_workling_options(["--", "-r", "Workling::Routing::ClassAndMethodRouting"]).should == {:routing_class => "Workling::Routing::ClassAndMethodRouting"}
  end

  specify "should parse the --routing option" do
    WorklingServer.parse_workling_options(["--", "--routing=Workling::Routing::ClassAndMethodRouting"]).should == {:routing_class => "Workling::Routing::ClassAndMethodRouting"}
  end


  specify "should parse the -l option" do
    WorklingServer.parse_workling_options(["--", "-l", "/var/www/current/app/workers"]).should == {:load_path => "/var/www/current/app/workers"}
  end

  specify "should parse the --load-path option" do
    WorklingServer.parse_workling_options(["--", "--load-path=/var/www/current/app/workers"]).should == {:load_path => "/var/www/current/app/workers"}
  end


  specify "should parse the -e option" do
    WorklingServer.parse_workling_options(["--", "-e", "production"]).should == {:rails_env => "production"}
  end

  specify "should parse the --environment option" do
    WorklingServer.parse_workling_options(["--", "--environment=production"]).should == {:rails_env => "production"}
  end


  specify "should ignore daemon options" do
    WorklingServer.parse_workling_options(["start", "--", "--environment=production"]).should == {:rails_env => "production"}
  end
end

context "building poller" do
  specify "should extract the relevant classes and objects" do
    options = {
      :client_class => "MyClient",
      :invoker_class => "MyInvoker",
      :routing_class => "MyRouting",
      :workling_root => "."
    }
    poller = WorklingServer.build_poller(options)
    poller.should.be.a.kind_of MyInvoker
    poller.router.should.be.a.kind_of MyRouting
    poller.client_class.should == MyClient
  end
end
