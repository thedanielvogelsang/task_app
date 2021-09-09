# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper

  helper_method :current_user
  helper_method :logged_in?

  before_action :authorize_user

  def authorize_user
    redirect_to '/task_app' unless logged_in?
  end
end
