class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  # def new
  #   @task = Task.new(params[:job])
  # end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "Task has been successfully created."
      redirect_to job_path(@task.job.id)
    else
      flash[:alert] = "Sorry, something went wrong."
      render :new
    end
  end

  # def edit
  # end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
    respond_to do |format|
      format.html { redirect_to job_path(task.job.id)}
      format.js
    end
  end

  # def destroy
  # end

private

  def task_params
    params.require(:task).permit(:description, :done, :job_id)
  end
end