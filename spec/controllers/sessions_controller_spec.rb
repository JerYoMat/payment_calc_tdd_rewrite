require 'spec_helper'
require 'pry'
describe SessionsController do 
    describe "Homepage" do
        it 'loads the homepage' do
          get '/'
          expect(last_response.status).to eq(200)
          expect(last_response.body).to include("Welcome to LoanCalc")
        end
      end
    
      describe "Signup Page" do
    
        it 'loads the signup page' do
          get '/signup'
          expect(last_response.status).to eq(200)
        end
    
        it 'signup directs user to loan index' do
          params = {
            :username => "skittles123",
            :email => "skittles@aol.com",
            :password => "rainbows"
          }
          post '/signup', params
          expect(last_response.location).to include("/loans")
        end
    
        it 'does not let a user sign up without a username' do
          params = {
            :username => "",
            :email => "skittles@aol.com",
            :password => "rainbows"
          }
          post '/signup', params
          expect(last_response.location).to include('/signup')
        end
    
        it 'does not let a user sign up without an email' do
          params = {
            :username => "skittles123",
            :email => "",
            :password => "rainbows"
          }
          post '/signup', params
          expect(last_response.location).to include('/signup')
        end
    
        it 'does not let a user sign up without a password' do
          params = {
            :username => "skittles123",
            :email => "skittles@aol.com",
            :password => ""
          }
          post '/signup', params
          expect(last_response.location).to include('/signup')
        end
    
        it 'creates a new user and logs them in on valid submission and does not let a logged in user view the signup page' do
          params = {
            :username => "skittles123",
            :email => "skittles@aol.com",
            :password => "rainbows"
          }
          post '/signup', params
          get '/signup'
          expect(last_response.location).to include('/loans')
        end
      end
    
      describe "login" do
        it 'loads the login page' do
          get '/login'
          expect(last_response.status).to eq(200)
        end
    
        it 'loads the loans index after login' do
          user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
          params = {
            :username => "becky567",
            :password => "kittens"
          }
          post '/login', params
          expect(last_response.status).to eq(302)
          follow_redirect!
          expect(last_response.status).to eq(200)
          expect(last_response.body).to include("Welcome,")
        end
    
        it 'does not let user view login page if already logged in' do
          user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
          params = {
            :username => "becky567",
            :password => "kittens"
          }
          post '/login', params
          get '/login'
          expect(last_response.location).to include("/loans")
        end
      end
    
      describe "logout" do
        it "lets a user logout if they are already logged in" do
          user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    
          params = {
            :username => "becky567",
            :password => "kittens"
          }
          post '/login', params
          get '/logout'
          expect(last_response.location).to include("/login")
        end
    
        it 'does not let a user logout if not logged in' do
          get '/logout'
          expect(last_response.location).to include("/")
        end
    
        it 'does not load /loans if user not logged in' do
          get '/loans'
          expect(last_response.location).to include("/login")
        end
    
        it 'does load /loans if user is logged in' do
          user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    
    
          visit '/login'
    
          fill_in(:username, :with => "becky567")
          fill_in(:password, :with => "kittens")
          click_button 'submit'
          expect(page.current_path).to eq('/loans')
        end
      end
end 