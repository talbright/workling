require 'optparse'

class WorklingServer

  def self.partition_options(args)
    daemon = []
    workling = []
    split_point = args.index("--") || args.size
    daemon = args[0...split_point] if split_point > 0
    workling = args[(split_point+1)..-1] if split_point and split_point < args.size
    [daemon, workling]
  end

  def self.partition_daemons_options(args)
    standard_options = %W{start stop restart run zap -t --ontop -f --force -h --help --version}
    pass_through = args.select { |a| standard_options.include? a }
    custom_options = args.reject { |a| standard_options.include? a }

    [pass_through, custom_options]
  end

  def self.parse_daemon_options(argv)
    options = {}
    pass_through, args = partition_daemons_options argv
    opts = OptionParser.new do |opts|
      opts.banner = 'Usage: myapp [options]'
      opts.separator ''
      opts.on('-a', '--app-name APP_NAME', String,"specify the process name") { |v| options[:app_name] = v }
      opts.on('-d', '--dir DIR', String, "the directory to run in") { |v| options[:dir] = v }
      opts.on('-m', '--monitor',"specify the process name") { |v| options[:monitor] = true }
      opts.on('-t', '--ontop') { |k, v| pass_through << v  }
    end
    opts.parse!(partition_options(args).first)
    options.merge(:ARGV => pass_through)
  end

  def self.parse_workling_options(args)
    options = {}
    opts = OptionParser.new do |opts|
      opts.banner = 'Usage: myapp [options]'
      opts.separator ''
      opts.on('-c', '--client CLIENT', String,"specify the client class") { |v| options[:client_class] = v }
      opts.on('-i', '--invoker INVOKER', String,"specify the invoker class") { |v| options[:invoker_class] = v }
      opts.on('-r', '--routing ROUTING', String,"specify the routing class") { |v| options[:routing_class] = v }
      opts.on('-l', '--load-path LOADPATH', String,"specify the load_path for the workers") { |v| options[:load_path] = v }
      opts.on('-e', '--environment ENVIRONMENT', String,"specify the environment") { |v| options[:rails_env] = v }
    end
    opts.parse!(partition_options(args).last)
    options
  end


  def self.build_poller(options)
    require 'workling/remote'
    ["remote/invokers/*.rb", "routing/*.rb"].each do |pattern|
      Dir.glob(pattern).each do |f|
        require File.join(File.dirname(f), File.basename(f, ".rb"))
      end
    end

    routing_class = Object.module_eval("::#{options[:routing_class]}")
    client_class = Object.module_eval("::#{options[:client_class]}")
    invoker_class = Object.module_eval("::#{options[:invoker_class]}")
    invoker_class.new(routing_class.new, client_class)
  end


  def self.run(options)
    WorklingServer.in_server_mode = true

    ENV["RAILS_ENV"] = options[:rails_env]
    puts "=> Loading Rails with #{ENV["RAILS_ENV"]} environment..."

    require options[:rails_root] + '/config/environment'

    Workling.load_path = options[:load_path]

    Workling::Discovery.discover!
    Workling.config

    poller = build_poller options

    puts '** Rails loaded.'
    puts "** Starting #{ poller.class }..."
    puts '** Use CTRL-C to stop.'

    ActiveRecord::Base.logger = Workling::Base.logger
    ActionController::Base.logger = Workling::Base.logger

    trap(:INT) { poller.stop; exit }

    begin
      poller.listen
    ensure
      puts '** No Worklings found.' if Workling::Discovery.discovered.blank?
      puts '** Exiting'
    end
  end
end
