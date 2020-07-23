class SessionsController < ApplicationController

  # function: new
  # purpose: none currently
  def new
  end

  # function: create
  # purpose: When a new session is created, this function is called. It authenticates
  # the user from the login page and directs them to their profile if successful and sets
  # the session ID to the current user.
  def create
    user = SecureUser.find_by email: (params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:username] = user.username
      redirect_to profile_index_url
    else
      flash.now[:alert] = "Email or password is invalid"
      render "new"
    end
  end

  # function: destroy
  # purpose: This function is called when the session is destroyed. It redirects them
  # to the login page.
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
