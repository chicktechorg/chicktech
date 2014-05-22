class EventsController < ApplicationController
  authorize_resource

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    if params[:city]
      @events = Event.where(:city_id => params[:city][:id])
      @city = City.find(params[:city][:id])
    else
      @events = Event.all
    end
    @events_by_date = @events.group_by(&:start_date)
    @templates = Event.where(:template => true)
    @upcoming = Event.upcoming
  end

  def new
    @event = Event.new
    @events = Event.all
    @leadership_role = LeadershipRole.new(leadable: @event)
  end

  def create
    @events = Event.all
    @event = Event.new(event_params)
    @cities = City.all
    if params[:event][:template_id]
      @template = Template.find(params[:event][:template_id])
      transfer_jobs =
      @event.jobs << @template.jobs
      @event.teams << @template.teams
      asdlkfjhasdf
      cloned_associations = self.dup :include => [{:jobs => :tasks}, {:teams => {:jobs => :tasks}}]
    end
    if @event.save
      flash[:notice] = "Event created successfully!"
      redirect_to new_event_path
    else
      render :new
    end
  end

  def show
    @events = Event.all
    @event = Event.find(params[:id])

  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:notice] = "Your event has been updated."
      redirect_to new_event_path
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    name = @event.name
    @event.destroy
    flash[:notice] = "Your event #{@name} has been destroyed."
    redirect_to new_event_path
  end

private

  def event_params
    params.require(:event).permit(:name, :description, :start, :finish, :city_id, :leadership_role_attributes => [:name, :leadable_id, :leadable_type])
  end
end
