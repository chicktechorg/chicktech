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
      redirect_to @job.event
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
    if params[:job][:signing_up]
      @job.update(user_id: current_user.id)
      flash[:notice] = "Congratulations! You are signed up for the job #{@job.name}."
      redirect_to @job
    elsif params[:job][:resigning]
      @job.update(user_id: nil)
      flash[:notice] = "You have resigned from the job #{@job.name}."
      redirect_to @job
    else 
      @job.update(job_params)
      flash[:notice] = "#{@job.name} got updated."
      redirect_to @job
    end
  end

  def show
    @job = Job.find(params[:id])
    @task = Task.new(params[:job_id])
  end

  def destroy
    @job = Job.find(params[:id])
    # name = @job.name
    @job.destroy
    flash[:notice] = "Job '#{@job.name}' deleted." #fixme does this actually work?
    redirect_to new_job_path 
  end

private

  def job_params
    params.require(:job).permit(:name, :event_id, :description) #fixme don't permit user id to be set externally
  end
end