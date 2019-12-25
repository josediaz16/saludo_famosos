module Contracts
  module MessageRequests
    class New < ApplicationContract
      json(Schemas::MessageRequests::Common)

      rule(:from, :recipient_type) do
        key.failure(:filled?) if values[:recipient_type].eql?('someone_else') && values[:from].blank?
      end
    end
  end
end
