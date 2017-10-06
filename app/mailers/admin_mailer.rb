class AdminMailer < ApplicationMailer

  default from: "innovation@unitransferklinik.de"

  def new_company_email(mail, company)
    @data = company
    mail(to: mail, subject: 'Eine neue Firma hat sich angemeldet.')
  end
end