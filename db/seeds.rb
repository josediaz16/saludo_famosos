# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "Creating Countries...."
ISO3166::Country.countries.each do |iso_country|
  if iso_country.country_code.present?
    Country.create!(
      name:                 iso_country.name,
      code_iso:             iso_country.alpha2,
      currency:             iso_country.currency_code.to_s,
      country_code:         iso_country.country_code,
      international_prefix: iso_country.international_prefix,
      region:               iso_country.region
    )
  else
    puts "#{iso_country.name} not created because it does not have country code"
  end
end
puts "...finished creation of countries"
