module Celebrities
  class Create
    include AppConfig::Transaction.new

    validate contract: Contracts::Celebrities::New.new(object_class: :celebrity)
    save     model_class: Celebrity
  end
end
