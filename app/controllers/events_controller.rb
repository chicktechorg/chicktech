class EventsController < ApplicationController
  authorize_resource

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    if params[:city]
      @events = Event.where(:city_id => params[:city][:id]).paginate(:per_page => 10, :page => params[:page])
      @city = City.find(params[:city][:id])
    else
      if current_user.role == "volunteer"
        @events = Event.where(:city_id => current_user.city).paginate(:per_page => 10, :page => params[:page])
      else
        @events = Event.all.paginate(:per_page => 10, :page => params[:page])
      end
    end
    @events_by_date = Event.all.group_by(&:start_date)
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
    if params[:event][:template_id] != ""
      @template = Template.find(params[:event][:template_id])
      @event = @template.create_event_from_template
      @event.update(event_params)
      flash[:notice] = "Event with template created successfully!"
      redirect_to new_event_path
    elsif @event.save
      flash[:notice] = "Event created successfully!"
      redirect_to event_path(@event)
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
