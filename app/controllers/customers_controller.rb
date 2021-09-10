class CustomersController < ApplicationController
  before_action :is_admin?, only: %i[update]

  def show
    @customer = Customer.find_by(id: params[:id])
  end

  def update
    customer = Customer.find_by(id: params[:id])
    if customer && customer.update(safe_params)
      flash[:notice] = 'Success!'
      redirect_back fallback_location: dashboard_path
    else
      render json: { error: customer.errors.full_messages }, status: 400
    end
  end

  def destroy
    render json: { message: 'Success!' }, status: 200
  end

  private

  def safe_params
    params.permit(:name)
  end
end
