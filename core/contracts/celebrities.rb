module Contracts
  module Celebrities
    class New < ApplicationContract
      json(Schemas::Celebrities::Common)
    end
    
    class Full < ApplicationContract
      json(Schemas::Celebrities::Full)
    end
  end
end
