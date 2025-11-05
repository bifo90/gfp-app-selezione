require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(
      email_address: "test@example.com",
      password: "password123",
      first_name: "John",
      last_name: "Doe"
    )
  end

  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should require email_address at database level" do
    @user.email_address = nil
    # Email is required at database level (null: false)
    # But validation may pass, so we test the database constraint
    assert_raises(ActiveRecord::NotNullViolation) do
      @user.save(validate: false)
    end
  end

  test "should require unique email_address" do
    duplicate_user = @user.dup
    @user.save!
    # Database has unique constraint, so it will raise an error
    assert_raises(ActiveRecord::RecordNotUnique) do
      duplicate_user.save(validate: false)
    end
  end

  test "should require password" do
    user = User.new(email_address: "test@example.com", first_name: "John", last_name: "Doe")
    assert_not user.valid?
  end

  test "should require first_name" do
    @user.first_name = nil
    assert_not @user.valid?
    assert_includes @user.errors[:first_name], "can't be blank"
  end

  test "should require last_name" do
    @user.last_name = nil
    assert_not @user.valid?
    assert_includes @user.errors[:last_name], "can't be blank"
  end

  test "full_name should concatenate first and last name" do
    assert_equal "John Doe", @user.full_name
  end

  test "should have many consumptions" do
    assert_respond_to @user, :consumptions
  end

  test "should destroy associated consumptions when user is destroyed" do
    @user.save!
    @user.consumptions.create!(
      consumption_type: "electricity",
      value: 10,
      date: Date.today
    )
    
    assert_difference "Consumption.count", -1 do
      @user.destroy
    end
  end

  test "should generate password_reset_token" do
    @user.save!
    # Rails 8 generates password_reset_token automatically when accessed
    token = @user.password_reset_token
    assert_not_nil token
    assert_kind_of String, token
  end

  test "should authenticate with correct password" do
    @user.save!
    assert @user.authenticate("password123")
  end

  test "should not authenticate with incorrect password" do
    @user.save!
    assert_not @user.authenticate("wrongpassword")
  end

  test "email_address should be case insensitive" do
    @user.email_address = "Test@Example.COM"
    @user.save!
    assert_equal "test@example.com", @user.email_address
  end

  test "should strip whitespace from email_address" do
    @user.email_address = "  test@example.com  "
    @user.save!
    assert_equal "test@example.com", @user.email_address
  end
end
