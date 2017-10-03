require 'bundler/setup'
require 'open-uri'

Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get '/update' do
  #Southwest Portland 97221
  # def self.search_craigs(url, quadrant)
  apartments_north_portland = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=1&search_distance=2&postal=97217&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "North Portland")

  apartments_northeast_portland = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=1&search_distance=2&postal=97213&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "Northeast Portland")

  apartments_northwest_portland = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=1&search_distance=2&postal=97229&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "Northwest Portland")

  apartments_southeast_portland = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=1&search_distance=2&postal=97206&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "Southeast Portland")

  apartments_southwest_portland = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=1&search_distance=2&postal=97221&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "Southwest Portland")

  all_quadrants = apartments_north_portland + apartments_northeast_portland + apartments_northwest_portland + apartments_southeast_portland + apartments_southwest_portland
  all_quadrants.each do |x|
    if Apartment.exists?({:name => x[:name],:address => x[:address],:price => x[:price]}) == false

      Apartment.create({:name => x[:name], :url => x[:url], :price => x[:price], :bed => x[:bed], :bath => x[:bath], :sqft => x[:sqft], :address => x[:address], :cat => x[:cat], :dog => x[:dog], :washer => x[:washer], :smoke => x[:smoke], :garage => x[:garage], :description => x[:description], :section => x[:section], :posted => x[:posted]})
    end
  end
redirect '/'
end

def ave_rent(array)
  avg = 0
  array.each do |listing|
    avg += listing.price
  end
  (avg / array.length)
end

# puts x = ave_rent(Apartment.where("rooms = '1'"))

def median(array)
  med = array[array.size/2]
  (med.price)
end

def ave_sqr(array)
  avg = 0
  array.each do |listing|
    avg += listing.sq_ft
  end
  (avg / array.length)
end

def median_sqr(array)
  med = array[array.size/2]
  (med.sq_ft)
end

# def percent_of(n)
#   self * 100.0 /n
# end

var http = require("http");
setInterval(function() {
    http.get("https://portland-rent-tracker.herokuapp.com/update");
}, 300000);

get '/' do
  @br1avg = ave_rent(Apartment.where("bed = '1'")).to_i
  @br1med = median(Apartment.where("bed = '1'")).to_i
  @br1high = Apartment.where('bed = 1').order(:price)[-1].price
  @br1low = Apartment.where('bed = 1').order(:price)[0].price
  @avg_percent = (@br1avg * 100.0 /@br1high).floor
  @med_percent = (@br1med * 100.0 /@br1high).floor
  @low_percent = (@br1low * 100.0 /@br1high).floor
  
  erb(:index)
end


get '/login' do
  erb(:login)
end

get '/user' do
  erb(:user)
end

get '/signup' do
  erb(:signup)
end

post '/login' do
  email = params['email']
  password = params['password']
  user = User.find_by_email(email)
  if user.password == password
    redirect("/user/#{user.id}")
  else
    erb(:login)
  end
end

post '/signup' do
  username = params['username']
  email = params['email']
  password = BCrypt::Password.create(params['password'])
  user = User.create({:username => username, :email => email, :password => password})
  redirect("/user/#{user.id}")
end

get 'user/:id' do
  erb(:user)
end
