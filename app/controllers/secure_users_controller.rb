class SecureUsersController < ApplicationController
  before_action :set_secure_user, only: [:show, :edit, :update, :destroy]

  # GET /secure_users
  # GET /secure_users.json
  def index
    @secure_user = SecureUser.all
  end

  # GET /secure_users/1
  # GET /secure_users/1.json
  def show
    puts params[:search_text]
    user = SecureUser.find_by firstname: (params[:search_text])
    puts user
  end

  # GET /secure_users/new
  def new
    @secure_user = SecureUser.new
  end

  # GET /secure_users/1/edit
  def edit
  end

  # POST /secure_users
  # POST /secure_users.json
  def create
    @secure_user = SecureUser.new(secure_user_params)

    respond_to do |format|
      if @secure_user.save
        # Now that they have successfully created a profile, direct them to their profile page
        session[:user_id] = @secure_user.id
        format.html { redirect_to profile_index_url, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @secure_user }
      else
        format.html { render :new }
        format.json { render json: @secure_user.errors, status: :unprocessable_entity }
      end
    end

    # Create user in CometChatPro
    parameters = {
      username: @secure_user.username,
      firstname: @secure_user.firstname
    }
    CometChatService.new(parameters).create_user

  end

  # PATCH/PUT /secure_users/1
  # PATCH/PUT /secure_users/1.json
  def update
    respond_to do |format|
      if @secure_user.update(secure_user_params)
        format.html { redirect_to profile_index_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @secure_user }
      else
        format.html { render :edit }
        format.json { render json: @secure_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secure_users/1
  # DELETE /secure_users/1.json
  def destroy
    # TODO: Delete user in CometChatPro
    # CometChatService.delete(@secure_user.username).delete_user

    # TODO: Remove user from all of their friend's friend lists

    # Remove user from database
    @secure_user.destroy
    respond_to do |format|
      format.html { redirect_to new_session_path, notice: 'User account was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secure_user
      @secure_user = SecureUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def secure_user_params
      params.require(:secure_user).permit(:email, :password, :password_confirmation, :username, :firstname, :lastname)
    end

    def comet_chat_pro_user_params
      params.require(:secure_user).permit(:username, :firstname)
    end
end
