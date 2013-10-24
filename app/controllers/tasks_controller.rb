class TasksController < ApplicationController
  authorize_resource
  
  def index
    @tasks = Task.all
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "Task has been successfully created."
      redirect_to job_path(@task.job)
    else
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
    respond_to do |format|
      format.html { redirect_to job_path(@task.job)}
      format.js
    end
  end

  def destroy
    @task = Task.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to job_path(@task.job)}
      format.js
    end
  end

private

  def task_params
    params.require(:task).permit(:description, :done, :job_id)
  end
end
