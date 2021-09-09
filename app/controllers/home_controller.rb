class HomeController < ApplicationController
  skip_before_action :authorize_user, only: :index

  def index
  end
end
