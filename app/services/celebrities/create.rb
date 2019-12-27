module Celebrities
  class Create
    include AppConfig::Transaction.new

    validate contract: Contracts::Celebrities::New.new(object_class: :celebrity)
    save     model_class: Celebrity
    tee :index_account

    def index_account(input)
      input[:model].reindex
    end
  end
end
