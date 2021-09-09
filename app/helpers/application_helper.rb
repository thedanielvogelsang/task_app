# frozen_string_literal: true

module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def signin_user(user)
    ua = user.user_authentication
    if ua.authenticate(params[:password])
      session[:user_id] = user.id
      ua.increment_login
    else
      false
    end
  end

  def logout
    session[:user_id] = nil
  end
end
