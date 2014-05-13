class EventsController < ApplicationController
  authorize_resource

  def index
    @events = Event.all
    if params[:city]
      @events = Event.where(:city_id => params[:city][:city_id])
      respond_to do |format|
        format.html { redirect_to user_path(current_user) }
        format.js
      end
    else
      @events = Event.all
    end
  end

  def new
    @event = Event.new
    @events = Event.upcoming
    @leadership_role = LeadershipRole.new(leadable: @event)
  end

  def create
    @event = Event.new(event_params)
    @cities = City.all
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
