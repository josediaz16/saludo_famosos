class Country < ApplicationRecord
  has_many :users

  validates :name, :code_iso, presence: true, uniqueness: true
  validates :country_code, presence: true
end
