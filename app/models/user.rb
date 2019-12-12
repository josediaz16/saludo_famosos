class User < ApplicationRecord
  has_secure_password

  belongs_to :country

  validates :email, uniqueness: true
end
