module Schemas
  module Users
    Common = Dry::Schema.JSON do
      required(:email).filled(:string, format?: Types::EMAIL_FORMAT)
      required(:password).filled(:string, min_size?: 8)
      required(:password_confirmation).filled(:string, min_size?: 8)
      required(:country_id).filled(:integer)
  
      optional(:phone).filled(Types::Phone, format?: Types::PHONE_FORMAT)
      optional(:id).filled(:integer)
      optional(:photo).filled
    end
  
    Celebrity = Dry::Schema.JSON(parent: Common) do
      required(:username).filled(:string)
      optional(:name).filled(:string)
    end
  
    Fan = Dry::Schema.JSON(parent: Common) do
      optional(:username).filled(:string)
      required(:name).filled(:string)
    end
  end

  module Celebrities
    Common = Dry::Schema.JSON do
      required(:price).filled(Types::Coercible::Float, gt?: 0)
      required(:user_id).filled(:integer)
      optional(:biography).filled(:string)
    end

    Full = Dry::Schema.JSON(parent: Users::Celebrity) do
      required(:celebrity).hash(Common)
    end
  end

  module Fans
    Common = Dry::Schema.JSON do
      required(:user_id).filled(:integer)
    end

    Full = Dry::Schema.JSON(parent: Users::Fan) do
      required(:fan).hash(Common)
    end
  end
end
