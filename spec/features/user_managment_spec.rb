require 'spec_helper'
require_relative './helpers/session'

include SessionHelpers

feature "User signs up" do


	scenario "when being logged out" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

	scenario "with a password that doesn't match" do
		expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by 0
	end

	scenario "with a password that doesn't match" do
		expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
    	expect(current_path).to eq('/users')
    	expect(page).to have_content("Password does not match the confirmation")
	end

	scenario "with an email that is already registered" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect{ sign_up }.to change(User, :count).by(0)
		expect(page).to have_content("This email is already taken")
	end

  scenario "tries to sign up with an empty password or email" do
      visit('/users/new')
      expect{ sign_up("","","") }.to change(User, :count).by 0
      expect(page).to have_content("Please sign up")
  end

	def sign_up (email = "alice@example.com", password = "oranges!",
				password_confirmation = 'oranges!')
			visit('/users/new')
			expect(page.status_code).to eq(200)
			fill_in :email, :with => email
			fill_in :password, :with => password
			fill_in :password_confirmation, :with => password_confirmation
			click_button 'Sign up'
	end	

end

feature "User signs in" do

	before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  	end

  scenario "with correct credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'test')
    expect(page).to have_content("Welcome, test@test.com")
  end

  scenario "with incorrect credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'wrong')
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

feature 'User signs out' do

  before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario 'while being signed in' do
    sign_in('test@test.com', 'test')
    click_button "Sign out"
    expect(page).to have_content("Good bye!")
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

	feature "user resets password &" do 

		before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test',
                :password_token => 'FDYUXSBUGTQEJDBGIIRICMDJQGNMADOKNRUFIRUBTHTLYOQBCWEZJZWMRLQGEHSA')
  	end
  	
    TOKEN = 'FDYUXSBUGTQEJDBGIIRICMDJQGNMADOKNRUFIRUBTHTLYOQBCWEZJZWMRLQGEHSA'

  	scenario "provides a valid email" do
  		reset_password
  		expect(page).to have_content("Hi test@test.com, an email on how to get a new password is on the way")
  		visit "/users/reset_password/:token"
  		expect(page.status_code).to eq(200)
  	end

    scenario "provides an email that is not on the the system" do
      reset_password("fake@email.co.uk")
      expect(page).to have_content("Your email fake@email.co.uk doesn't match any record in our db, please try again")
    end

    scenario "clicks on the email link sent by our app and has a valid token" do
      visit("/users/reset_password/#{TOKEN}")
      expect(page).to have_content("Please choose a new password")
    end

    scenario "visits the reset password route with an invalid token" do
      visit("/users/reset_password/fake_token")
      expect(page).to have_content("Apologies, but your token is not in our system please request a new one")
    end

    scenario "introduces a wrong password confirmation in reset password" do
      visit("/users/reset_password/#{TOKEN}")
      fill_in :password, :with => "password"
      fill_in :password_confirmation, :with => "wrong pass"
      click_button "Reset password"
      expect(page).to have_content("Passwords don't match, please try again.")
    end

    scenario "introduces the right password confirmation in reset password" do
      visit("/users/reset_password/#{TOKEN}")
      fill_in :password, :with => "password"
      fill_in :password_confirmation, :with => "password"
      click_button "Reset password"
      expect(page).to have_content("Password changed")
    end

    scenario "visits the reset password route after one hour" do
       @user = User.first(:password_token => TOKEN)
       @user.password_token_timestamp = Time.new(1)
       @user.save
       visit("/users/reset_password/#{TOKEN}")
       expect(page).to have_content("Your email reset period has expired please request it again.")
    end
  

  	def reset_password(email = "test@test.com")
  		visit '/forgotten'
  		expect(page.status_code).to eq(200)
  		expect(page).not_to have_content("Welcome, test@test.com")
  		fill_in :email, :with => email
  		click_button "forgotten"
  	end

	end



