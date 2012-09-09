require "classical_analysis/version"
require 'nokogiri'

module ClassicalAnalysis
  class AllClassicalDoc
    def self.run
      entries = []
      # http://www.allclassical.org/assets/playlist/playlistFormat.php?t=0.7356784949079156&day=2012-09-01
      doc = Nokogiri::HTML(open('playlistFormat.html'))
      doc.css('ul').each do |ul|
        entry = {}
        ul.children.each do |li|
          li.children.each do |span|
            if !span['class'].nil? && span['class'] != 'pl_buynow'
              entry[span['class'][3..-1]] = span.text
            end
          end
        end
        entries << entry
        # TODO store in redis
      end
      puts entries.length
    end
  end
end
