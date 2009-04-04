puts '=> Loading Rails...'

require File.dirname(__FILE__) + '/../../../../config/environment'
require File.dirname(__FILE__) + '/../lib/workling/remote'
require File.dirname(__FILE__) + '/../lib/workling/routing/class_and_method_routing'

client = Workling::Remote.dispatcher.client
invoker = Workling::Remote.invoker
routing = Workling::Remote.routing

# TODO - must be a better way of passing in ARGV here...
poller = invoker.new(routing.new(ARGV[0], ARGV[1], ARGV[2], ARGV[3]), client.class)

puts '** Rails loaded.'
puts "** Starting #{invoker}, #{routing} ..."
puts '** Use CTRL-C to stop.'

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.logger = Workling::Base.logger
end

if defined?(ActionController::Base)
  ActionController::Base.logger = Workling::Base.logger
end

trap(:INT) { poller.stop; exit }

begin
  poller.listen
ensure
  puts '** No Worklings found.' if Workling::Discovery.discovered.blank?
  puts '** Exiting'
end

def tail(log_file)
  cursor = File.size(log_file)
  last_checked = Time.now
  tail_thread = Thread.new do
    File.open(log_file, 'r') do |f|
      loop do
        f.seek cursor
        if f.mtime > last_checked
          last_checked = f.mtime
          contents = f.read
          cursor += contents.length
          print contents
        end
        sleep 1
      end
    end
  end
  tail_thread
end
