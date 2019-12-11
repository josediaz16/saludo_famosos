class ApplicationContract < Dry::Validation::Contract
  config.messages.default_locale = :es
  config.messages.backend = :i18n
  config.messages.load_paths << 'config/errors.yml'
end
