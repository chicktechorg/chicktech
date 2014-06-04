class UserMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  default from: 'noreply@chicktech.herokuapp.com'

  def welcome_email(user)
    @user = user
    @url = 'http://chicktech.org/login'
    mail(to: @user.email, subject: 'Welcome to Chicktech')
  end

  def send_information(user)
    @user = user
    @url = 'http://chicktech.org/login'
    mail(to: @user.email, subject: 'ChickTech Updates')
  end

  def invite_volunteer(user, event)
    @user = user
    @event = event
    @url = "http://chicktech.org/events/#{@event.id}"

    mail(to: @user.email, subject: "#{@event.name} has #{pluralize(@event.number_of_available_positions, 'more position')} to be filled")
  end
end
