module Fans
  class Create
    include AppConfig::Transaction.new

    validate contract: Contracts::Fans::New.new(object_class: :fan)
    save     model_class: Fan
  end
end
