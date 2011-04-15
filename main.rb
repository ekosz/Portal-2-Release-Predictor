require 'rubygems'
require 'sinatra'
require 'linefit'
require 'open-uri'
require 'yaml'

get '/' do

  hash = YAML.load open('http://www.csh.rit.edu/~ekosz/portal.yml')
  lr = LineFit.new
  start = hash[:x][0]
  lr.setData(hash[:x].map{|m|m-start}, hash[:y])
  intercept, @slope = lr.coefficients
  @timetil = Time.at( ((100-intercept)/@slope).to_i + start).strftime("%m/%d/%Y %I:%M%p")


  haml :index
end
