class ProfileController < ApplicationController

################################################################################
# function: index
# purpose: Performs the following functions when profile page is loaded:
# 1) Looks up and displays the current user's friend list
# 2) Displays a form for finding friends
################################################################################
  def index

####Code for displaying friend list

    # Look up friendlist column from database
    secure_users_friendlist = SecureUser.select(:friendlist).where(id: session[:user_id])
    # Create an empty array and assign friendlist to it
    friendlist_user_ids = Array.new
    secure_users_friendlist.each do |f|
      friendlist_user_ids = f.friendlist.to_a
    end

    # Get list of users based on friendlist
    @secure_user_friendlist = SecureUser.where(id: friendlist_user_ids).order("firstname")

####Code for displaying friend requests

    # Look up friendlist column from DB
    secure_users_friendrequests = SecureUser.select(:friendrequests).where(id: session[:user_id])
    # Create an empty array and assign friendrequests to it
    friendrequest_user_ids = Array.new
    secure_users_friendrequests.each do |f|
      friendrequest_user_ids = f.friendrequests.to_a
    end

    # Get list of users based on friendlist
    @secure_user_friendrequests = SecureUser.where(id: friendrequest_user_ids).order("firstname")

####Code for finding friends

    # Search for users
    if params[:search_text]
      # Perform search based on name or username
      @users = SecureUser.search(params[:search_text])
      # Remove users who are already in the user's friendlist
      @users = @users.reject {|alreadyfriend| @secure_user_friendlist.include? alreadyfriend}
      # Remove the user themself, if they are returned from the search
      @users = @users.delete_if {|themself| themself.id == session[:user_id]}
      # Set display message if no users were returned
      if @users.empty?
        respond_to do |format|
          format.html {redirect_to profile_index_url, alert: 'No results' }
        end
      end
    end
  end

################################################################################
# function: addfriendrequest
# purpose: This method is called when the user clicks to add a user as their
# friend.
################################################################################
  def addfriendrequest

    # Assign requestee and requestor to variable
    requested_friend_id = params[:user_to_add]
    requesting_friend_id = session[:user_id]

    # Look up friendrequests column from database for user we are wanting to add
    secure_users_friendrequests = SecureUser.select(:friendrequests).where(id: requested_friend_id)

    # Create an empty array and assign friendrequests to it
    friendrequests = Array.new
    secure_users_friendrequests.each do |f|
      friendrequests = f.friendrequests.to_a
    end

    # Creating string array
    friendrequests_string = Array.new
    friendrequests.each { |a| friendrequests_string.push(a.to_s) }

    # Add requesting user to their friendrequests
    friendrequests_string.push(requesting_friend_id)

    # Run update and check status of it
    requested_friend = SecureUser.find_by id: (requested_friend_id)
    requested_friend.friendrequests = friendrequests_string
    respond_to do |format|
      if requested_friend.save
        format.html { redirect_to profile_index_url, alert: 'Friend request sent!' }
      else
        format.html { redirect_to profile_index_url, alert: 'Unable to add friend :(' }
     end
   end
  end

################################################################################
# function: acceptfriendrequest
# purpose: This function is called when a user clicks 'Accept' on a friend request.
################################################################################
  def acceptfriendrequest

    # Get current user and requesting user ids and assign to variables
    requesting_friend_id = params[:user_to_add]
    current_user_id = session[:user_id]

    # Look up columns from database for current user and requesting user
    current_user_lists = SecureUser.select(:friendlist, :friendrequests).where(id: current_user_id)
    requesting_user_lists = SecureUser.select(:friendlist).where(id: requesting_friend_id)

    # Create new arrays for current user and assign lists to them
    current_user_friendlist = Array.new
    current_user_friendrequests = Array.new
    current_user_lists.each do |f|
      current_user_friendlist = f.friendlist.to_a
      current_user_friendrequests = f.friendrequests.to_a
    end

    # Creating string arrays
    current_user_friendlist_string = Array.new
    current_user_friendlist.each { |a| current_user_friendlist_string.push(a.to_s) }
    current_user_friendrequests_string = Array.new
    current_user_friendrequests.each { |a| current_user_friendrequests_string.push(a.to_s) }

    # Create new arrays for requesting user and assign friendlist to it
    requesting_user_friendlist = Array.new
    requesting_user_lists.each do |f|
      requesting_user_friendlist = f.friendlist.to_a
    end

    # Creating string array
    requesting_user_friendlist_string = Array.new
    requesting_user_friendlist.each { |a| requesting_user_friendlist_string.push(a.to_s) }

    # Add requesting user to current user's friend list and remove requesting user from current user's friend requests
    current_user_friendlist_string.push(requesting_friend_id)
    current_user_friendrequests_string.delete(requesting_friend_id)

    # Add current user to the requesting user's friend list
    requesting_user_friendlist_string.push(current_user_id)

    # Set values for current user's write to database
    current_user = SecureUser.find_by id: (current_user_id)
    current_user.friendlist = current_user_friendlist_string
    current_user.friendrequests = current_user_friendrequests_string

    # Set values for requesting user's write to database
    requesting_user = SecureUser.find_by id: (requesting_friend_id)
    requesting_user.friendlist = requesting_user_friendlist_string

    # Run updates and display according messages
    respond_to do |format|
      if current_user.save && requesting_user.save
        format.html { redirect_to profile_index_url, alert: 'Friend request accepted!' }
      else
        format.html { redirect_to profile_index_url, alert: 'Unable to accept friend request :(' }
      end
    end
  end

################################################################################
# function: deletefriendrequest
# purpose: This function is called when the user clicks to delete a friend request.
################################################################################
  def deletefriendrequest

    # Get current user and requesting user ids and assign to variables
    requesting_friend_id = params[:user_to_delete]
    current_user_id = session[:user_id]

    # Look up columns from database for current user and requesting user
    current_user_lists = SecureUser.select(:friendrequests).where(id: current_user_id)

    # Create new arrays for current user and assign lists to them
    current_user_friendrequests = Array.new
    current_user_lists.each do |f|
      current_user_friendrequests = f.friendrequests.to_a
    end

    # Creating string array
    current_user_friendrequests_string = Array.new
    current_user_friendrequests.each { |a| current_user_friendrequests_string.push(a.to_s) }

    # Remove requesting user from current user's friend requests
    current_user_friendrequests_string.delete(requesting_friend_id)

    # Set values for current user's write to database
    current_user = SecureUser.find_by id: (current_user_id)
    current_user.friendrequests = current_user_friendrequests_string

    # Run updates and display according messages
    respond_to do |format|
      if current_user.save
        format.html { redirect_to profile_index_url, alert: 'Friend request deleted!' }
      else
        format.html { redirect_to profile_index_url, alert: 'Unable to delete friend request :(' }
      end
    end
  end

################################################################################
# function: deletefriend
# purpose: This function is called when the user clicks to delete an existing friend.
################################################################################
  def deletefriend

    # Get current user and friend's user ids and assign to variables
    friend_id = params[:user_to_delete]
    current_user_id = session[:user_id]

    # Look up columns from database for current user and requesting user
    current_user_lists = SecureUser.select(:friendlist).where(id: current_user_id)
    friend_user_lists = SecureUser.select(:friendlist).where(id: friend_id)

    # Create new arrays for current user and assign lists to them
    current_user_friendlist = Array.new
    current_user_lists.each do |f|
      current_user_friendlist = f.friendlist.to_a
    end

    # Creating string array
    current_user_friendlist_string = Array.new
    current_user_friendlist.each { |a| current_user_friendlist_string.push(a.to_s) }

    # Create new arrays for friend and assign friendlist to it
    friend_user_friendlist = Array.new
    friend_user_lists.each do |f|
      friend_user_friendlist = f.friendlist.to_a
    end

    # Creating string array
    friend_user_friendlist_string = Array.new
    friend_user_friendlist.each { |a| friend_user_friendlist_string.push(a.to_s) }

    # Remove friend from current user's friend list
    current_user_friendlist_string.delete(friend_id)
    # Remove current user from the friend's friend list
    friend_user_friendlist_string.delete(current_user_id.to_s)

    # Set values for current user's write to database
    current_user = SecureUser.find_by id: (current_user_id)
    current_user.friendlist = current_user_friendlist_string

    # Set values for friend's write to database
    friend = SecureUser.find_by id: (friend_id)
    friend.friendlist = friend_user_friendlist_string

    # Run updates and display according messages
    respond_to do |format|
      if current_user.save && friend.save
        format.html { redirect_to profile_index_url, notice: 'Friend deleted!' }
      else
        format.html { redirect_to profile_index_url, notice: 'Unable to delete friend :(' }
      end
    end
  end
end
