source "https://rubygems.org"

gem "jets"


# Include pg gem if you are using ActiveRecord, remove next line
# and config/database.yml file if you are not
gem "pg", "~> 1.1.3"
gem 'bcrypt', '~> 3.1.7'
gem 'jwt'

gem "dynomite"
gem 'dry-monads'
gem 'dry-validation'
gem 'dry-transaction'

gem 'countries'

# development and test groups are not bundled as part of the deployment
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'shotgun'
  gem 'rack'
  gem 'puma'
end

group :test do
  gem 'rspec' # rspec test group only or we get the "irb: warn: can't alias context from irb_context warning" when starting jets console
  gem 'launchy'
  gem 'capybara'
  gem 'factory_bot'
  gem 'database_cleaner'
  gem 'faker'
end
