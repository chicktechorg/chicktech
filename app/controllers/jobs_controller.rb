class JobsController < ApplicationController
  def index
    @jobs = Job.all
  end

  def new
    @job = Job.new(:event_id => params[:event_id])
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:notice] = "#{@job.name} has been successfully created."
      redirect_to event_path(@job.event.id)
    else
      flash[:alert] = "Something went wrong."
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(params[:job].permit(:name, :description))
      flash[:notice] = "#{@job.name} got updated."
      redirect_to jobs_path
    else
      render :edit
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  def destroy
    @job = Job.find(params[:id])
    name = @job.name
    @job.destroy
    flash[:notice] = "Job '#{name}' deleted."
    redirect_to new_job_path 
  end

private

  def job_params
    params.require(:job).permit(:name, :event_id, :description)
  end
end