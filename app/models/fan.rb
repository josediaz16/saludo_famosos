class Fan < ApplicationRecord
  belongs_to :user
  has_many   :message_requests
end
