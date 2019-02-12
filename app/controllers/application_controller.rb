require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :index
  end

  helpers do 
    def current_user
      if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])  # Same as @current_user = @current_user || User.find_by(id: session[:user_id])
      end 
    end

    def logged_in?
      !!current_user
    end


  end 



end
