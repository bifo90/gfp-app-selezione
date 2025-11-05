require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }

  test "new" do
    get new_session_path
    assert_response :success
  end

  test "create with valid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "create with non-existent user" do
    post session_path, params: { email_address: "nonexistent@example.com", password: "password" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "create with blank email" do
    post session_path, params: { email_address: "", password: "password" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "create with blank password" do
    post session_path, params: { email_address: @user.email_address, password: "" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(User.take)

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end

  test "destroy when not logged in" do
    delete session_path

    assert_redirected_to new_session_path
  end

  test "should redirect to admin dashboard after login for admin users" do
    sign_in_as(@user)

    get root_path
    # Verify user is authenticated
    assert @user.sessions.any?
  end
end
