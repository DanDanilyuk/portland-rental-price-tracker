
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
