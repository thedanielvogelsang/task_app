class TaskLogsController < ApplicationController
  def create
    task_log = TaskLog.new(safe_params.merge(user_id: current_user.id))
    if task_log.save
      flash[:notice] = 'Success!'
      redirect_back fallback_location: dashboard_path
    else
      render json: { errors: task_log.errors.full_messages }, status: 404
    end
  end

  private

  def safe_params
    params.permit(:duration_minutes, :task_id)
  end
end
