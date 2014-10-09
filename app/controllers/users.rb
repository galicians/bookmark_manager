
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

	@user = User.first(:email => params[:email])
	
	if @user
		@user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
		@user.password_token_timestamp = Time.now
		@user.save
		send_simple_message(@user)
		flash[:notice] = 'Please check your email inbox, you should see an email password request.'
		redirect '/'
	else
		flash[:notice] = "Your email #{params[:email]} doesn't match any record in our db, please try again"
		redirect '/forgotten'
	end
end

post "/password_change" do

	@password_confirmed = params[:password] == params[:password_confirmation]
	
	if @password_confirmed
		p session.inspect
		@user = User.first(:email => session[:user])
		p @user.email
		@user.password = params[:password]
		@user.save
		flash[:notice] = "Password changed"
		redirect '/'
	else
		flash[:notice] = "Passwords don't match, please try again."
		erb :"users/reset_password"
	end
end

get "/users/reset_password/:token" do
	puts "#{params[:token]}"
	@user = User.first(:password_token => params[:token])

	if !@user
		flash[:notice] = "Apologies, but your token is not in our system please request a new one"
		redirect '/forgotten'
	end

	@on_time = Time.now - @user.password_token_timestamp < 3600

	if !@on_time
		flash[:notice] = "Your email reset period has expired please request it again."
		redirect '/forgotten'
	end
	session[:user] = "#{@user.email}"
	erb :"users/reset_password"
end


