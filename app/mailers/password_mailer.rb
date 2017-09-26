class PasswordMailer < ApplicationMailer

  default from: "innovation@unitransferklinik.de"

  def reset_password_email(user, password)
    @u = user
    @pw = password
    mail(to: @u.email, subject: 'Ihr Passwort wurde zurückgesetzt.')
  end
end