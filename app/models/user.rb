class User < ApplicationRecord
  include ImageUploader::Attachment(:photo)
  has_secure_password

  belongs_to :country
  has_many :user_roles
  has_many :roles, through: :user_roles

  has_one  :celebrity
  has_one  :fan

  validates :email, uniqueness: true
end
