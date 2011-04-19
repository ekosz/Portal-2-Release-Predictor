require 'rubygems'
require 'sinatra'
require 'linefit'
require 'open-uri'
require 'yaml'
require 'rack/cache'

use Rack::Cache

before do
  expires 1800, :public
end

get '/' do

  hash = YAML.load File.read "portal.yml"
  lr = LineFit.new
  start = hash[:x][0]
  lr.setData(hash[:x].map{|m|m-start}, hash[:y])
  intercept, @slope = lr.coefficients
  at_100 = ((100-intercept)/@slope).to_i + start 
  @time_string = Time.at( at_100 ).strftime("%A %I:%M%p %Z")
  @time = at_100 * 1000

  @scatter_data = hash[:x].zip(hash[:y]).map {|m| [m[0]*1000, m[1]]}.to_s
  @line_data = [ [start*1000, intercept], [at_100*1000, 100] ].to_s


  haml :index
end
