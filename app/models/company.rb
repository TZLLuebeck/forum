class Company < ApplicationRecord
  
  mount_uploader :logo, LogoUploader

  has_many :users, dependent: :destroy
  has_many :interests, through: :users
end
