class UserMailer < ActionMailer::Base
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
    @positions_to_fill = "#{(@event.number_of_teams - @event.number_of_teams_with_leaders) + (@event.number_of_jobs - @event.number_of_jobs_with_volunteers)}"

    if @positions_to_fill.to_i > 1
      mail(to: @user.email, subject: "#{@event.name} has #{@positions_to_fill} more positions to be filled")
    else
      mail(to: @user.email, subject: "#{@event.name} has #{@positions_to_fill} more position to be filled")
    end
  end
end
