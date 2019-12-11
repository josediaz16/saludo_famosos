class ApplicationContract < Dry::Validation::Contract
  config.messages.default_locale = :es
  config.messages.backend = :i18n
  config.messages.load_paths << 'config/errors.yml'

  option :object_class

  register_macro(:confirmation) do
    field_a, field_b = keys

    if values[field_a] != values[field_b]
      key.failure(text: :confirmation, code: :confirmation, input: values[field_a])
    end
  end
end
