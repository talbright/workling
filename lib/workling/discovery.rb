#
#  Discovery is responsible for loading workers in app/workers. 
#
module Workling
  class Discovery
    def self.discovered
      @discovered ||= []
    end
    
    # requires worklings so that they are added to routing. 
    def self.discover!
      Workling.load_path.map{|p| Dir.glob("#{p}/**/*.rb")}.flatten.each{|wling| require wling}
    end
  end
end
