require 'rubygems'
require 'sinatra'

get "/" do
  "hello"
  
end

get "/monkeys/:monkey_name" do
  @how_many_monkeys = 3 + 5
  @monkey_name = params[:monkey_name]
  @possible_monkey_names = ["bobo", "princess", "joe"]
  
  erb :monkey # => views/monkey.erb
end