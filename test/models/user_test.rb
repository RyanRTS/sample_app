require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = User.new(name:"Test User", email:"test@mail.com", 
                    password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a"*250 + "@email.com"
    assert_not @user.valid?
  end
  
  test "email should accept valid addresses" do
    invalid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user_email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email should be saved as lower case" do
    mixed_case_email = "fOo@ExamPle.com"
    @user.email = mixed_case_email
    @user.save
    assert mixed_case_email.downcase, @user.reload.email
  end
  
  test "authenticated? should return false for user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have minimum length" do 
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow user" do
    ryan = users(:ryan)
    archer = users(:archer)
    assert_not ryan.following?(archer)
    ryan.follow(archer)
    assert ryan.following?(archer)
    assert archer.followers.include?(ryan)
    ryan.unfollow(archer)
    assert_not ryan.following?(archer)
  end
  
  test "feed should have the right posts" do
    ryan    = users(:ryan)
    archer  = users(:archer)
    lana    = users(:lana)
    # posts from followed user
    lana.microposts.each do |post_following|
      assert ryan.feed.include?(post_following)
    end
    # posts from self
    ryan.microposts.each do |post_self|
      assert ryan.feed.include?(post_self)
    end
    # post from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not ryan.feed.include?(post_unfollowed)
    end
  end
  
end
