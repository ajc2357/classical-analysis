require 'classical_analysis/version'
require 'date'
require 'nokogiri'
require 'open-uri'
require 'mysql'

##
# Module for collecting playlist data for classical music stations.
module ClassicalAnalysis
  ##
  # Class for collecting playlist data from All Classical 89.9.
  class AllClassical899
    ##
    # Request playlist information from allclassical.org for a range of dates.
    def self.collect start_date = Date.parse('2012-05-18'), end_date = Date.today
      db = db_init

      (start_date..end_date).each do |date|
        puts "Check #{date}"

        url = "http://www.allclassical.org/assets/playlist/playlistFormat.php?day=#{date}"
        doc = Nokogiri::HTML open(url)
        doc.css('ul').each do |ul|
          entry = {'date' => date}
          ul.children.each do |li|
            if !li.children.empty?
              span = li.first_element_child
              if !span['class'].nil? && span['class'] != 'pl_buynow'
                key = span['class'][3..-1]
                value = span.text
                entry[key] = db.quote value
              end
            end
          end

          stmt = "insert into entries (#{entry.keys.join(', ')}) values ('#{entry.values.join('\', \'')}')"
          db.query stmt
        end
      end
      db.close
    end

    def self.db_init db
      db = Mysql::new('localhost', 'some_user', 'some_pass', 'classical_analysis')
=begin
          create database if not exists classical_analysis;
=end
      stmt = <<EOS
create table if not exists entries (
  id int auto_increment,
  date date not null,
  time time not null,
  composer varchar(255) null,
  conductor varchar(255) null,
  ensemble varchar(255) null,
  labelcatalog varchar(255) null,
  soloist varchar(255) null,
  title varchar(255) null,
  primary key (id)
);
EOS
      db.query stmt
      db
    end
  end
end