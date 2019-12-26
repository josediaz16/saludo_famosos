class Celebrity < ApplicationRecord
  include CelebritySearchable

  belongs_to :user
  has_many   :message_requests
end
