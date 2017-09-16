class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable

  has_many :interests, dependent: :destroy
  belongs_to :companies, optional: true
  accepts_nested_attributes_for :roles, allow_destroy: true

  after_create :assign_default_role

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  def self.update_roles(params)
    params.each do |user_param|
      u = User.find(user_param[:id])
      user_param[:roles_attributes].each do |role_param|
        if role_param[:_destroy]
          u.remove_role(role_param[:name].to_sym)
        else
          u.add_role(role_param[:name].to_sym)
        end
      end
    end
  end
end
