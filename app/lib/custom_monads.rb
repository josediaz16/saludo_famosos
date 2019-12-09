require 'dry/monads/maybe'

module CustomMonads
  def self.Zero(value)
    Dry::Monads.Maybe(value)
      .bind do |num_value|
        if value.zero?
          Dry::Monads.None
        else
          Dry::Monads.Some(value)
        end
      end
  end
end
