module Contracts
  module Users
    class New < ApplicationContract
      json(Schemas::Users::Celebrity)
      rule(:password_confirmation, :password).validate(:confirmation)
    end
  end
end
