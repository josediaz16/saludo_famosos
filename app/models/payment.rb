class Payment < ApplicationRecord
  belongs_to :message_request
end
