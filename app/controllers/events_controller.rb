#fixme remove comments
#fixme line break at end

class EventsController < ApplicationController
  authorize_resource
  def index
    @events = Event.all

  end

  def new
    @event = Event.new
    @events = Event.all
    # authorize! :create, @event
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:notice] = "Event created successfully!"
      redirect_to @event
    else
      render :new
    end
    # authorize! :create, @event
  end

  def show
    @event = Event.find(params[:id])
    # authorize! :read, @event
  end

  def edit 
    @event = Event.find(params[:id])
    render :edit #fixme don't need to call render when template has same name as action
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:notice] = "Your event has been updated."
      redirect_to event_path
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    name = @event.name
    @event.destroy
    flash[:notice] = "Your event #{@name} has been destroyed."
    redirect_to events_path
  end

#line breaks!

private

  def event_params
    params.require(:event).permit(:name, :description, :start, :finish)
  end
end