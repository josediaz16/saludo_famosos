module CelebritySearchable
  extend ActiveSupport::Concern
  include Dry::Monads[:maybe]

  included do
    searchkick(
      callbacks: false,
      word_start: [:name, :username, :country],
      suggest: [:name, :username, :country],
      index_name: -> { "celebrities_#{Jets.env}" }
    )

    scope :search_import, -> { includes(user: :country) }

    def search_data
      {
        name: user.name,
        username: user.username,
        biography: biography,
        price: price,
        country: user.country.name,
        code_iso: user.country.code_iso,
        photo_url: Maybe(user.photo).bind(&:url).value_or(nil),
        created_at: created_at,
        photo_position: photo_position,
        handle: handle,
      }
    end
  end
end
