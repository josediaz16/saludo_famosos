module Common
  BasicTxBuilder = -> contract, model_class, &block do
    Class.new do
      include AppConfig::Transaction.new

      validate contract: contract.new(object_class: model_class.to_s.underscore)
      save     model_class: model_class

      class_eval(&block) if block.present?
    end
  end
end
