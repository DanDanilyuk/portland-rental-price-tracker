require 'bundler/setup'
require 'open-uri'
require 'pry'


Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }


apartments = Apartment.search_craigs

apartments.each do |apartment|
  if Apartment.exists?({:title => apartment[4], :price => apartment[0], :sq_ft => apartment[1], :rooms => apartment[3], :location => apartment[2]}) == false

    Apartment.create({:title => apartment[4], :price => apartment[0], :sq_ft => apartment[1], :rooms => apartment[3], :location => apartment[2], :url => nil, :quadrant => nil})
  end
end

def ave_rent(array)
  avg = 0
  array.each do |listing|
    avg += listing.price
  end
  avg / array.length
end
#
# puts x = ave_rent(Apartment.where("rooms = '1'"))
#

get '/' do
  erb(:index)
end

get '/login' do
  erb(:login)
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

get '/signup' do
  erb(:signup)
end

post '/signup' do
  username = params['username']
  email = params['email']
  password = BCrypt::Password.create(params['password'])
  user = User.create({:username => username, :email => email, :password => password})
  redirect("/user/#{user.id}")
end
