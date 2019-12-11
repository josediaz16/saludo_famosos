module Countries
  extend Dry::Monads[:maybe]

  FindByCodeIso = -> code_iso do
    country = Country.find_by(code_iso: code_iso)

    Maybe(country)
      .bind { |value| Maybe(value.id) }
      .value_or(nil)
  end
end
