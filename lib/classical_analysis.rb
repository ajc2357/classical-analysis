require 'classical_analysis/version'
require 'nokogiri'
require 'open-uri'
require 'redis'

# Module for collecting playlist data for classical music stations.
module ClassicalAnalysis
  # Class for collecting playlist data from All Classical 89.9.
  class AllClassical899
    # Request playlist information from allclassical.org for a range of dates.
    # Store the data in Redis.
    def self.run
      db = Redis.new(:host => '127.0.0.1', :port => 6379)
      9.times do |day|
        date = "2012-09-%02d" % [day + 1]
        puts "Check #{date}"
        # t=0.7356784949079156&
        url = "http://www.allclassical.org/assets/playlist/playlistFormat.php?day=#{date}"
        doc = Nokogiri::HTML(open(url))
        doc.css('ul').each do |ul|
          entry = {}
          ul.children.each do |li|
            if !li.children.empty?
              span = li.first_element_child
              if !span['class'].nil? && span['class'] != 'pl_buynow'
                entry[span['class'][3..-1]] = span.text
              end
            end
          end
          # store data in redis
          db.hmset "#{date} #{entry['time']}", *entry.flatten
        end
      end
    end
  end
end
