class Company < ApplicationRecord
  
  mount_uploader :logo, LogoUploader

  has_many :users, dependent: :destroy
  has_many :interests, through: :users

  after_create :inform_admins

  def inform_admins
    admin1 = "nils.eckardt@unitransferklinik.de"
    admin2 = "braunt@protonmail.com"    
    AdminMailer.new_company_email(admin1, self).deliver_later
    AdminMailer.new_company_email(admin2, self).deliver_later
  end
end
