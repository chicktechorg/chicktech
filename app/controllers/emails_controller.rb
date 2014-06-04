class EmailsController < ApplicationController
  include ActionView::Helpers::TextHelper
  def create
    @event = Event.find(params[:event_id])
    @event.city.users.each do |user|
      UserMailer.invite_volunteer(user, @event).deliver
    end
    flash[:notice] = "#{pluralize(@event.city.users.count, 'invitation email')} sent."
    redirect_to event_path(@event)
  end
end
