require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'yaml'

@file = 'public_html/portal.yml'

def update
    doc = Nokogiri::HTML(open('http://www.aperturescience.com/glados@home/'))
        doc.xpath("//div[@id='overall_progress_bar']").each do |link|
        link[:style] =~ /(\d+)px/
        percent = (($1.to_f/494.to_f) * 100).to_i
        puts "Last Percent: #{last_percent}\n\tNew Percent: #{percent} (#{Time.now})"
        if percent > last_percent
            last_percent = percent
            val_hash[:x] << Time.now.to_i
            val_hash[:y] << percent
            puts "Writing #{val_hash.inspect} (#{Time.now})"
            File.open(@file, 'w') do |file|
              file.write YAML.dump val_hash
            end
        end
    end
end

def last_percent
  @percent ||= begin
 tmp =  YAML.load(File.read(@file))
 if tmp
     tmp[:y].last
else
    0
    end
end
end

def last_percent=(val)
  @percent = val
end

def val_hash
  @hash ||= YAML.load(File.read(@file)) || {:x=>[], :y=>[]}
end

loop do
  update
  sleep 60
end

