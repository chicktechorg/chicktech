class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new(params[:job])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "Task has been successfully created."
      redirect_to :index
    else
      flash[:alert] = "Sorry, something went wrong."
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

private

  def task_params
    params.require(:task).require(:description, :done, :job_id)
  end
end