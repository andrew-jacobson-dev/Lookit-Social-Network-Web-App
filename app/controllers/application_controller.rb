class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  helper_method :current_user

  # function: current_user
  # purpose: Sets a session variable called user_id with the user id of the logged in user
  def current_user
    if session[:user_id]
      @current_user ||= SecureUser.find(session[:user_id])
    else
      @current_user = nil
    end
  end

end
