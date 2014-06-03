class EmailsController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    @event.city.users.each do |user|
      UserMailer.invite_volunteer(user, @event).deliver
    end
    redirect_to event_path(@event)
  end
end
