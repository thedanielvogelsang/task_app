class ProjectsController < ApplicationController
  def index
    @projects = Project.all.order(id: :asc)
  end

  def show
    @project = Project.find_by(id: params[:id])
    @tasks = @project.tasks
  end

  def update
    project = Project.find_by(id: params[:id])
    if project && project.update(safe_params)
      render json: { project: project }, status: 200
    else
      render json: { error: project.errors.full_messages }, status: 400
    end
  end

  def destroy
    render json: { message: 'Success!' }, status: 200
  end

  private

  def safe_params
    params.require(:project).permit(:name)
  end
end
