
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
	send_simple_message
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
