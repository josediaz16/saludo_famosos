CommonUserSchema = Dry::Schema.JSON do
  required(:email).filled(:string, format?: Types::EMAIL_FORMAT)
  required(:password).filled(:string, min_size?: 8)
  required(:password_confirmation).filled(:string, min_size?: 8)
  required(:country_id).filled(:integer)

  optional(:phone).filled(Types::Phone, format?: Types::PHONE_FORMAT) 
  optional(:id).filled(:integer)
  optional(:photo).filled
end

NewCelebritySchema = Dry::Schema.JSON(parent: CommonUserSchema) do
  required(:username).filled(:string)
  optional(:name).filled(:string)
end

NewFanSchema= Dry::Schema.JSON(parent: CommonUserSchema) do
  optional(:username).filled(:string)
  required(:name).filled(:string)
end

class NewUserContract < ApplicationContract
  json(NewCelebritySchema)

  rule(:password_confirmation, :password).validate(:confirmation)
end
