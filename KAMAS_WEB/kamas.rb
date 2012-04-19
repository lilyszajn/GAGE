require 'rubygems'
require 'sinatra'
require 'json'
require 'user.rb'
require 'tip.rb'

get "/user/new" do
  erb :new_user
end

post "/users" do
  u = User.new
  u.first_name = params[:first_name]
  u.last_name = params[:last_name]
  u.username = params[:username]
  u.password = params[:password]
  u.save
  
  redirect "/user/#{u.id}"
end

# /user/7
get "/user/:id" do
  @user = User.get params[:id] #=> 7 
  erb :user
end

get "/tip/new" do
  erb :new_tip
end

post "/tips" do
  

  # use a Tip model to save the data from the form
  # redirect the user to "/tips/#{tip.id}"
  t = Tip.new
   t.tip = params[:tip]
   t.tip_category = params[:tip_category]
#   t.tip_popularity = params[:tip_popularity]
   t.save

   redirect "/tip/#{t.id}"
end

# copy get "/user/:id"
get "/tip/:id" do
  # get the tip
  # render the template (tip.erb)
  @tip = Tip.get params[:id]
  erb :tip 
end
# parse tips to json objects
get "/borough/:tip_category.json" do
  @tips = Tip.all :tip_category => params[:tip_category]
  @tips.collect{|t| t.to_json}.to_json
end

get "/borough/:tip_category" do
  @tips = Tip.all :tip_category => params[:tip_category]
  
  erb :borough
end

# random tip page: (homepage)
get "/" do
  # get last Tip, save it in @tip
  # render template for showing tips
  # this assumes there are tips
  # so on first run it will break
  ## NEED TO CHANGE TO @tip = Tip.all.random OR ideally @tip = Tip.all.geolocation
  @tip = Tip.all.last #=> 7 
  erb :tip
end

# TODO:
# write a Tip class (similar to User class) X
# define the attributes of a tip in that class X
# create a new_tip.erb template X
# create a form so the user can enter those tip attributes (action and method)
# use form data to create and save a new Tip (in post "/tips") X
# create a tip.erb tempalte to display a tip X
# find the most recent tip and give it to the template X
