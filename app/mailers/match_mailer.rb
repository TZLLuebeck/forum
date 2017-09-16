class MatchMailer < ApplicationMailer

  default from: "innovation@unitransferklinik.de"

  def one_for_all_email(user, post)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Ein neues Angebot könnte Sie interessieren.')
  end

  def all_for_one_email(user, posts)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: '')
  end

end
