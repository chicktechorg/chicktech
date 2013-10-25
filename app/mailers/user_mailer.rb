class UserMailer < ActionMailer::Base
  default from: 'noreply@chicktech.mailgun.org'

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
end
