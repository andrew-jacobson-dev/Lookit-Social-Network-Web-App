class ChatController < ApplicationController

  # function: index
  # purpose: Performs the following actions when the chat page is loaded
  # 1) Looks up the current user's friend list
  def index
    # Look up friendlist column from DB
    secure_users_friendlist = SecureUser.select(:friendlist).where(id: session[:user_id])
    # Create an empty array and assign friendlist to it
    secure_users_friend = Array.new
    secure_users_friendlist.each do |f|
      secure_users_friend = f.friendlist.to_a
    end
    # Get list of users based on friendlist
    secure_users_friends = SecureUser.where(id: secure_users_friend).order("firstname")
    @secure_user_friendlist = secure_users_friends
  end

  # function: new
  # purpose: none presently
  def new
  end

  # function: create
  # purpose: none presently
  def create
  end
end
