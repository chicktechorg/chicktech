class TemplatesController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    template = @event.create_template
    redirect_to event_path(@event), notice: "Template saved."
  end
end
