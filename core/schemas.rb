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

  module MessageRequests
    ValidRecipientTypes = %w[me someone_else]

    Common = Dry::Schema.JSON do
      required(:phone_to).value(Types::Phone, format?: Types::PHONE_FORMAT)
      required(:to).filled(:string)
      required(:brief).filled(:string, size?: 20..700)
      required(:reference_code).filled(:string)
      required(:celebrity_id).filled(:integer)
      required(:recipient_type).filled(:string, included_in?: ValidRecipientTypes)
      optional(:fan_id).filled(:integer)
      optional(:from).value(:string)
    end
  end
end
