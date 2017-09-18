class WelcomeMailer < ApplicationMailer

  default from: "plattform@unitransferklinik.de"

  def welcome_email(user)
  	@user = user
    mail(to: @user.email, subject: 'Ihre Registrierung bei der Innovationsplattform Krankenhaus 4.0')
  end

  def interest_email(user)
  	@user = user
  	mail(to: @user.email, subject: 'Ihre Anzeige wurde erfolgreich veröffentlicht.')
  end
end
