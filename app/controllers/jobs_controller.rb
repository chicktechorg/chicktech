class JobsController < ApplicationController
  def index
    @jobs = Job.all
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:notice] = "#{@job.name} has been successfully created."
      redirect_to new_job_path
    else
      flash[:alert] = "Something went wrong."
      render :new
    end
  end

  def show
    @job = Job.find(params[:id])
  end

private

  def job_params
    params.require(:job).permit(:name, :event_id, :description)
  end
end