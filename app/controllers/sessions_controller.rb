class SessionsController < ApplicationController
  skip_before_action :authorize_user
  def create
    user = User.find_by(email: params[:email])
    if user && signin_user(user)
      flash[:message] = 'Success!'
      redirect_to dashboard_path
    else
      flash[:message] = 'Username/Password invalid. Please try again.'
      redirect_to '/task_app'
    end
  end

  def destroy
    flash[:message] = 'Success'
    session[:user_id] = nil
    redirect_to root_path
  end
end
