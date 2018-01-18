require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
                                        
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'li', 'Email is invalid'
    assert_select 'li', 'Password confirmation doesn\'t match Password'
    assert_select 'li', 'Password is too short (minimum is 6 characters)'
    # assert_select 'div.danger alert-danger'
  end
  
  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {  name: "Ryan",
                                          email: "ryan@mail.com",
                                          password: "password",
                                          password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #Try to login before activating
    log_in_as user
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not user.activated?
    assert_not is_logged_in?
    # Valid token, invalid email
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    # Valid acivation
    get edit_account_activation_path(user.activation_token, email: user.email)
    follow_redirect!
    # assert_template 'users/show'
    assert_not flash.empty?
    # assert_select 'div.alert-success', 'Welcome!'
    assert is_logged_in?
  end
  
end
