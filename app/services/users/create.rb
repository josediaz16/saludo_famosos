module Users
  class Create
    include AppConfig::Transaction.new

    map  :find_country
    validate contract: Contracts::Users::New.new(object_class: :user)
    save     model_class: User

    def find_country(input)
      Fns::H::RenameKey.(:country, :country_id, Countries::FindByCodeIso).(input)
    end

  end
end
