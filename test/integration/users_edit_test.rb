require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:ryan)
    @other_user = users(:archer)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {   name: "",
                                                email: "test@invalid",
                                                password: "foo",
                                                password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select 'div.alert', "The form contains 4 errors."
  end
  
  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: {   name: name,
                                                email: email,
                                                password: "",
                                                password_confirmation: "" } }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    
  end
  
  test "friendly forwarding for user edit page" do
    get edit_user_path(@user)
    assert_redirected_to login_path
    assert_match '/edit', session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    delete logout_path
    log_in_as(@user)
    assert session[:forwarding_url].nil?
    assert_redirected_to @user
  end
  
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: {   name: @user.name,
                                                email: @user.email,
                                                password: "",
                                                password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to @other_user
  end
  
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: {   name: @user.name,
                                                email: @user.email,
                                                password: "",
                                                password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @other_user
  end
  
end
