require 'sinatra'
require 'data_mapper'
require './lib/link' # this needs to be done after datamapper is initialised
require './lib/tag'
require './lib/user'
require './helpers/application'
require 'rack-flash'

env = ENV["RACK_ENV"] || "development"
# we're telling datamapper to use a postgres database on localhost. The name will be "bookmark_manager_test" or "bookmark_manager_development" depending on the environment
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
# After declaring your models, you should finalise them
DataMapper.finalize
# However, the database tables don't exist yet. Let's tell datamapper to create them


	use Rack::Flash, :sweep => true
	set :views, Proc.new { File.join(root, "..","views") }
	set :public_folder, 'public'
	enable :sessions
	set :session_secret, 'super secret'


get '/' do
  @links = Link.all
  erb :index
end

post '/links' do
  url = params["url"]
  title = params["title"]
	 tags = params["tags"].split(" ").map do |tag|
	  Tag.first_or_create(:text => tag)
	end
	Link.create(:url => url, :title => title, :tags => tags)
  redirect to('/')
end

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get '/users/new' do
	@user = User.new
	erb :"users/new"
end

post '/users' do
	@user = User.create(:email => params[:email],
							:password => params[:password],
							:password_confirmation => params[:password_confirmation])
	if @user.save
		session[:user_id] = @user.id
		redirect to('/')
	else
		flash.now[:errors] = @user.errors.full_messages
		erb :"users/new"
	end
end

get '/sessions/new' do
  erb :"sessions/new"
end

post '/sessions' do
  email, password = params[:email], params[:password]
  user = User.authenticate(email, password)
  if user
    session[:user_id] = user.id
    redirect to('/')
  else
    flash[:errors] = ["The email or password is incorrect"]
    erb :"sessions/new"
  end
end


delete '/sessions' do
  flash[:notice] = "Good bye!"
  session[:user_id] = nil
  redirect to('/')
end

get '/forgotten' do
	erb :"users/forgotten_password"
end

post '/forgotten' do
	puts "your email is #{params[:email]}"
	@dummy_user = User.create(:email => 'hello@hello.com',
							:password => 'xxx',
							:password_confirmation => 'xxx',
							:password_token => 'password_token',
							:password_token_timestamp => Time.now)
	puts @dummy_user.password_token
	@user = User.first(:email => params[:email])
	puts "user email is#{@user.email}"
	@user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
	@user.password_token_timestamp = Time.now
	@user.save
	puts @user.password_token
	puts @user.password_token_timestamp
	
	# u.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
	# user.password_token_timestamp = Time.now
	# user.save
	erb :"users/waiting_email"
end

get "/users/reset_password/:token" do
	# user = User.first(:password_token => token)
	erb :"users/reset_password"
end

post "users/password_changed" do

end










