module SessionsHelper
  
  #log in user
  def log_in(user)
    session[:user_id]  = user.id
  end
  
  def current_user
    # if @current_user.nil?
    #   @current_user = User.find_by(id: session[:user_id])
    # else
    #   @current_user
    # end
    @current_user ||= User.find_by(id: session[:user_id])
    # above code is same as below code:
    # @current_user = @current_user || User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
end
