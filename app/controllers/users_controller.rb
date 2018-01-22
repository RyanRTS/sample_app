class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # user is saved to db
      @user.send_activation_email
      flash[:info] = "Please check email to activate account"
      redirect_to root_url
    else
      render 'new' #unable to save user, bring back the new user page
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.where(activated: true).find(params[:id])
    if @user.update_attributes(user_params)
      # successful update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, 
                                  :password, :password_confirmation)
    end
    
    # Before filters
    
    # Confirms the user making edits is the correct user
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "You can only edit your profile"
        redirect_to current_user
      end
    end
    
    # check if logged in user is admin before deleting another user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
