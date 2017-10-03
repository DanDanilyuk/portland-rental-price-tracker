require 'bundler/setup'
require 'pry'
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

#Index Routes
get('/') do

  erb(:index)
end
