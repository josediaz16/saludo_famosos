class User < ApplicationRecord
  include ImageUploader::Attachment(:photo)
  has_secure_password

  belongs_to :country

  validates :email, uniqueness: true
end
