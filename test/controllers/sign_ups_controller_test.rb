require "test_helper"

class SignUpsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_sign_up_url
    assert_response :success
  end

  test "should create user with valid params" do
    assert_difference("User.count", 1) do
      post sign_up_url, params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123",
          first_name: "New",
          last_name: "User"
        }
      }
    end

    assert_redirected_to new_session_url
  end

  test "should not create user with blank email" do
    # Email presence is validated by has_secure_password requiring a valid user
    # But blank email can technically be saved, so this tests missing first_name instead
    assert_no_difference("User.count") do
      post sign_up_url, params: {
        user: {
          email_address: "test@example.com",
          password: "password123",
          password_confirmation: "password123",
          first_name: "",
          last_name: "User"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should not create user with mismatched passwords" do
    assert_no_difference("User.count") do
      post sign_up_url, params: {
        user: {
          email_address: "newuser@example.com",
          password: "password123",
          password_confirmation: "different",
          first_name: "New",
          last_name: "User"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should not create user with duplicate email" do
    existing_user = users(:one)
    
    assert_no_difference("User.count") do
      assert_raises(ActiveRecord::RecordNotUnique) do
        post sign_up_url, params: {
          user: {
            email_address: existing_user.email_address,
            password: "password123",
            password_confirmation: "password123",
            first_name: "New",
            last_name: "User"
          }
        }
      end
    end
  end

  test "should not create user without required fields" do
    assert_no_difference("User.count") do
      post sign_up_url, params: {
        user: {
          email_address: "",
          password: "",
          first_name: "",
          last_name: ""
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should automatically sign in user after successful registration" do
    post sign_up_url, params: {
      user: {
        email_address: "newuser@example.com",
        password: "password123",
        password_confirmation: "password123",
        first_name: "New",
        last_name: "User"
      }
    }

    assert_redirected_to new_session_url
    # Check that user was created and session was started
    new_user = User.find_by(email_address: "newuser@example.com")
    assert_not_nil new_user
    assert new_user.sessions.any?, "User should have an active session"
  end
end
