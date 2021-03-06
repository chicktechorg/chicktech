class JobsController < ApplicationController
  authorize_resource

  def index
    @jobs = Job.all
  end

  def new
    @job = Job.new(job_params)
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      respond_to do |format|
        flash[:notice] = "#{@job.name} has been successfully created."
        format.html { redirect_to @job.workable }
        format.js
      end
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    #TODO look into handling this with AJAX
    @job = Job.find(params[:id])
    if params[:signing_up]
      @job.update(user_id: current_user.id)
      flash[:notice] = "Congratulations! You are signed up for the job #{@job.name}."
      redirect_to event_path(@job.get_event)
    elsif params[:resigning]
      @job.update(user_id: nil)
      flash[:notice] = "You have resigned from the job #{@job.name}."
      redirect_to event_path(@job.get_event)
    elsif params[:job][:user_id]
      @user = params[:job][:user_id]
      @job.update(user_id: @user)
      flash[:notice] = "Congratulations! You are signed up for the job #{@job.name}."
      redirect_to event_path(@job.get_event)
    elsif params[:job][:job_done]
      @job.change_status
      @job.save
      flash[:notice] = "You have changed the job completion status."
      redirect_to event_path(@job.get_event)
    else
      @job.update(job_params)
      flash[:notice] = "#{@job.name} got updated."
      redirect_to event_path(@job.get_event)
    end
  end

  def show
    @job = Job.find(params[:id])
    @task = Task.new(params[:job_id])
    @comment = Comment.new(:commentable => @job)
    @commentable = @job
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    flash[:notice] = "Job '#{@job.name}' deleted."
    redirect_to @job.workable
  end

private

  def job_params
    params.require(:job).permit(:name, :workable_id, :workable_type, :description, :due_date, :done)
  end
end
