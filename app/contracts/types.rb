module Types
  include Dry::Types()

  DB_PHONE_SUB_FORMAT = /(?:\+\d{2}(?: |)|[\D])/
  PHONE_FORMAT = /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/
  EMAIL_FORMAT = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ 

  Phone = Types::String.constructor do |value|
    value.gsub(DB_PHONE_SUB_FORMAT, "")
  end
end
