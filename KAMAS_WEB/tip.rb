require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:///Users/lilyszajnberg/Sites/ui/urban_insider.db')

class Tip
#  attr_accessor :tip, :tip_category, :tip_popularity
  include DataMapper::Resource   
  property :id,           Serial
  property :tip,          String
  property :tip_category,        String
  property :tip_popularity,       String
  property :lat,  String
  property :long, String
  
  # TODO:
  # add properties for lat and long X
  # make sure they come in in the form (via js?)
  # make sure the sinatra action saves that data in the object
  
  # then, in the client/i.e. template/i.e. javascript
  # use the data coming back from $.getJSON
  # to make a series of map calls
  
  def to_json
    {:lat => lat, :long => long}
  end
  
  #def html
  #  <<-ANYTHING
   # <div style="first_name:#{width}px; background-color:##{hex_value}; height:#{height}px">
    #&nbsp;
    #</div>
    #ANYTHING
  #end
end