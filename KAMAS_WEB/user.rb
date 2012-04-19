require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:///Users/lilyszajnberg/Sites/ui/urban_insider.db')

class User
#  attr_accessor :first_name, :last_name, :alias_name, :password
  include DataMapper::Resource   
  property :id,           Serial
  property :first_name,    String
  property :last_name,        String
  property :username,       String
  property :password,       String
  
  #def html
  #  <<-ANYTHING
   # <div style="first_name:#{width}px; background-color:##{hex_value}; height:#{height}px">
    #&nbsp;
    #</div>
    #ANYTHING
  #end
end