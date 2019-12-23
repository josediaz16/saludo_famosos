module Contracts
  module Fans
    class New < ApplicationContract
      json(Schemas::Fans::Common)
    end
  end
end
