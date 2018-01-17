require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:ryan)
  end
  
  test "layout links when no user is logged in" do
    #checks fro presence of 'a' tag with href set as given path
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_url, count: 2
    #header links
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", logout_path, count: 0
    #footer links
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
  end
  
  test "layout links when user is logged in" do
    #checks fro presence of 'a' tag with href set as given path
    log_in_as @user
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_url, count: 2
    #header links
    assert_select "a[href=?]", users_path, count: 1
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", logout_path
    #footer links
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
  end
  
end
