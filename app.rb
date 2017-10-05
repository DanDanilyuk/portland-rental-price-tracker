require 'bundler/setup'
require 'open-uri'


Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

Dynopoker.configure do |config|
	config.address = 'https://portland-rent-tracker.herokuapp.com/update'
end

get '/' do
  @br1avg = ave_rent(Apartment.where("bed = '1'")).to_i
  @br1med = median(Apartment.where("bed = '1'")).to_i
  @br1high = Apartment.where('bed = 1').order(:price)[-1].price
  @br1low = Apartment.where('bed = 1').order(:price)[0].price
	@br1sqr = ave_sqr(Apartment.where('bed = 1')).to_i
  @avg_percent = (@br1avg * 100.0 /@br1high).floor
  @med_percent = (@br1med * 100.0 /@br1high).floor
  @low_percent = (@br1low * 100.0 /@br1high).floor
	#north
	if Apartment.where("price < #{@br1avg} and bed = '1' and sqft > #{@br1sqr} and section = 'North Portland'").exists?
		@best_deal_N = best_deal(Apartment.where("price < #{@br1avg} and bed = '1' and sqft > #{@br1sqr} and section = 'North Portland'").order(:price))
	else
		@best_deal_N = Apartment.where("bed = 1 and section = 'North Portland'").order(:price)[0]
	end
	#northeast
	if Apartment.where("price < #{@br1avg} and bed = '1' and sqft > #{@br1sqr} and section = 'Northeast Portland'").exists?
		@best_deal_NE = best_deal(Apartment.where("price < #{@br1avg} and bed = '1' and sqft > #{@br1sqr} and section = 'Northeast Portland'").order(:price))
	else
		@best_deal_NE = Apartment.where("bed = 1 and section = 'Northeast Portland'").order(:price)[0]
	end
	#northwest
	if Apartment.where("price < #{@br1avg} and bed = '1' and sqft > #{@br1sqr} and section = 'Northwest Portland'").exists?
		@best_deal_NW = best_deal(Apartment.where("price < #{@br1avg} and bed = '1' and sqft > #{@br1sqr} and section = 'Northwest Portland'").order(:price))
	else
		@best_deal_NW = Apartment.where("bed = 1 and section = 'Northwest Portland'").order(:price)[0]
	end
	#southwest
	if Apartment.where("price < #{@br1avg} and bed = '1' and sqft > #{@br1sqr} and section = 'Southwest Portland'").exists?
		@best_deal_SW = best_deal(Apartment.where("price < #{@br1avg} and bed = '1' and sqft > #{@br1sqr} and section = 'Southwest Portland'").order(:price))
	else
		@best_deal_SW = Apartment.where("bed = 1 and section = 'Southwest Portland'").order(:price)[0]
	end
	#southeast
	if Apartment.where("price < #{@br1avg} and bed = '1' and sqft > #{@br1sqr} and section = 'Southeast Portland'").exists?
		@best_deal_SE = best_deal(Apartment.where("price < #{@br1avg} and bed = '1' and sqft > #{@br1sqr} and section = 'Southeast Portland'").order(:price))
	else
		@best_deal_SE = Apartment.where("bed = 1 and section = 'Southeast Portland'").order(:price)[0]
	end
  erb(:index)
end

get '/login' do
  erb(:login)
end

post '/login' do
  email = params['email']
  password = params['password']
  user = User.find_by_email(email)
  if BCrypt::Password.new(user.password) == password
    redirect("/user/#{user.id * 793}")
  else
    erb(:login)
  end
end

get '/user/:id' do
	id = (params[:id]).to_i/793
	@all = []
	@search = []
	@user = User.find_by_id(id)
  erb(:user)
end

post '/user/:id' do
	id = (params[:id]).to_i/793
	@user = User.find_by_id(id)
	if params['bed']
		bed_search = ""
		params['bed'].each do |bed|
			bed_search += "bed = #{bed} or "
		end
		bed_search = bed_search[0..-5]
	end

	if params['bath']
		bath_search = ""
		params['bath'].each do |bath|
			bath_search += "bath = #{bath} or "
		end
		bath_search = bath_search[0..-5]
	end

	if params['section']
		section_search = ""
		params['section'].each do |section|
			section_search += "section = '#{section}' or "
		end
		section_search = section_search[0..-5]
	end

	combined_search = ""

	if bed_search
		combined_search += " " + "(" + bed_search + ") and"
	end

	if bath_search
		combined_search += " " + "(" + bath_search + ") and"
	end

	if section_search
		combined_search += " " + "(" + section_search + ") and"
	end

	if params['sqft'] != ''
		sqft_search = " and sqft > #{params['sqft']}"
	end

	combined_search = combined_search[1..-5]

	if combined_search && params['sqft'] != ''
		combined_search += sqft_search
	elsif params['sqft'] != ''
		combined_search = "sqft > #{params['sqft']}"
	end
	@search = Apartment.where(combined_search).order(:price)
	@all = Apartment.all
	erb(:user)
end

get '/confirm' do
	erb(:confirm)
end

get '/signup' do
  erb(:signup)
end

post '/signup' do
  username = params['username']
  email = params['email']
	password = params['password']
	confirm_pass = params['confirm_pass']
	if password == confirm_pass
  	password = BCrypt::Password.create(password)
	else
		redirect("/confirm")
	end
  user = User.create({:username => username, :email => email, :password => password})
  redirect("/user/#{user.id * 793}")
end

post '/confirm' do
  username = params['username']
  email = params['email']
	password = params['password']
	confirm_pass = params['confirm_pass']
	if password == confirm_pass
  	password = BCrypt::Password.create(password)
	else
		redirect("/confirm")
	end
	user = User.create({:username => username, :email => email, :password => password})
  redirect("/user/#{user.id * 793}")
end

get '/update' do
  #Southwest Portland 97221
  # def self.search_craigs(url, quadrant)

  apartments_north_portland1 = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=1&search_distance=2&postal=97217&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "North Portland")

  apartments_north_portland2 = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=1&search_distance=2&postal=97203&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "North Portland")

  apartments_northeast_portland = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=1&search_distance=3&postal=97213&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "Northeast Portland")

  apartments_northwest_portland = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=1&search_distance=2&postal=97229&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "Northwest Portland")

  apartments_southeast_portland = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=1&search_distance=3.5&postal=97206&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "Southeast Portland")

  apartments_southwest_portland = Apartment.search_craigs('https://portland.craigslist.org/search/apa?postedToday=0&search_distance=3.5&postal=97221&min_price=499&max_price=6001&min_bedrooms=1&min_bathrooms=1&minSqft=1&availabilityMode=0', "Southwest Portland")

  all_quadrants = apartments_north_portland1 + apartments_north_portland2 + apartments_northeast_portland + apartments_northwest_portland + apartments_southeast_portland + apartments_southwest_portland
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
    avg += listing.sqft
  end
  (avg / array.length)
end

def median_sqr(array)
  med = array[array.size/2]
  (med.sq_ft)
end

def count_ammenity(listing)
	ammenity_count = 0
	if listing.cat
		ammenity_count +=1
	end
	if listing.dog
		ammenity_count +=1
	end
	if listing.washer
		ammenity_count +=1
	end
	if listing.smoke
		ammenity_count +=1
	end
	if listing.garage
		ammenity_count +=1
	end
	return ammenity_count
end

# pass in Apartment.where("price < #{@br1avg}, bed = '1', sqft > #{@br1sqr}").order(:price)
def best_deal(array)
	ammenity_count = 0
	array.each do |listing|
		ammenity_count = count_ammenity(listing)
		if ammenity_count >= 3
			return listing
		end
	end
	array.each do |listing|
		ammenity_count = count_ammenity(listing)
		if ammenity_count >= 0
			return listing
		end
	end
end
