class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = "Account not activated. Check email for activation link"
        redirect_to root_url
      end
    else
      # error message
      flash.now[:danger] = "Incorrect email/password combination"
      render 'new'
    end
  end
  
  def destroy
    # remove session and redirect to home page
    log_out if logged_in?
    redirect_to root_url
  end
  
  
end
