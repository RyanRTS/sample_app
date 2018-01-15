class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # user is saved to db
      flash[:success] = "Welcome!"
      redirect_to @user #@user.id
    else
      render 'new' #unable to save user, bring back the new user page
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, 
                                  :password, :password_confirmation)
    end
  
end
