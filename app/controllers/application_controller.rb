# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper

  helper_method :current_user
  helper_method :logged_in?
  helper_method :admin_privs?

  before_action :authorize_user

  def authorize_user
    redirect_to '/' unless logged_in?
  end

  def admin_privs?
    current_user.admin? ? true : false
  end

  def is_admin?
    unless admin_privs?
      respond_to do |format|
        format.html do
          flash[:notice] = 'User not authorized. No op.'
          redirect_to customer_path(params[:id])
        end
        format.json { render json: { error: 'User not authorized' }, status: 404 }
      end
    end
  end
end
