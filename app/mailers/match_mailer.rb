class MatchMailer < ApplicationMailer

  default from: "innovation@unitransferklinik.de"

  def one_for_all_email(user, post)
    @user = user
    @post = post
    mail(to: @user.email, subject: 'Eine neue Anzeige könnte Sie interessieren.')
  end

  def all_for_one_email(user, posts)
    @user = user
    @posts = posts
    mail(to: @user.email, subject: 'Es wurden Anzeigen für Sie gefunden.')
  end
end