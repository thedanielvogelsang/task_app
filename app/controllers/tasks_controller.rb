class TasksController < ApplicationController
  def show
    @task = Task.find_by(id: params[:id])
    @project = @task.project
    @task_logs = @task.task_logs
    render 'tasks/show'
  end

  def create
    task = Task.new(safe_params)
    if task.save
      flash[:notice] = 'Success!'
      redirect_back fallback_location: dashboard_path
    else
      render json: { errors: task.errors.full_messages }, status: 404
    end
  end

  def update
    task = Task.find_by(id: params[:id])
    if task && task.update(safe_params)
      render json: { task: task }, status: 200
    else
      render json: { error: task.errors.full_messages }, status: 400
    end
  end

  def destroy
    render json: { message: 'Success!' }, status: 200
  end

  private

  def safe_params
    params.permit(:description, :project_id)
  end
end
