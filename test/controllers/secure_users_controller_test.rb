require 'test_helper'

class SecureUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @secure_user = secure_users(:one)
  end

  test "should get index" do
    get secure_users_url
    assert_response :success
  end

  test "should get new" do
    get new_secure_user_url
    assert_response :success
  end

  test "should create secure_user" do
    assert_difference('SecureUser.count') do
      post secure_users_url, params: { secure_user: { email: @secure_user.email, password: 'secret', password_confirmation: 'secret' } }
    end

    assert_redirected_to secure_user_url(SecureUser.last)
  end

  test "should show secure_user" do
    get secure_user_url(@secure_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_secure_user_url(@secure_user)
    assert_response :success
  end

  test "should update secure_user" do
    patch secure_user_url(@secure_user), params: { secure_user: { email: @secure_user.email, password: 'secret', password_confirmation: 'secret' } }
    assert_redirected_to secure_user_url(@secure_user)
  end

  test "should destroy secure_user" do
    assert_difference('SecureUser.count', -1) do
      delete secure_user_url(@secure_user)
    end

    assert_redirected_to secure_users_url
  end
end
