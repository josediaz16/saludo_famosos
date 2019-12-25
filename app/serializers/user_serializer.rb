class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :name, :username, :phone

  attribute :country do |object|
    object.country.code_iso
  end

  has_one :celebrity, if: Proc.new { |record| record.celebrity.present? }
  has_one :fan, if: Proc.new { |record| record.fan.present? }

  has_many :roles
end
