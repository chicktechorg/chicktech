class EmailsController < ApplicationController
  include ActionView::Helpers::TextHelper
  def create
    @event = Event.find(params[:event_id])
    if params[:request]
      @user = current_user
      @admins = []
      @admins << User.where(:role => "superadmin")
      @admins << User.where(:role => "admin")
      @admins.each do |admin|
        UserMailer.leadership_request(admin, @user, @event).deliver
      end
      flash[:notice] = "Request email sent"
      redirect_to event_path(@event)
    else
      @event.city.users.each do |user|
        UserMailer.invite_volunteer(user, @event).deliver
      end
      flash[:notice] = "#{pluralize(@event.city.users.count, 'invitation email')} sent."
      redirect_to event_path(@event)
    end
  end
end
