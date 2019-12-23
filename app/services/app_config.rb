module AppConfig

  class Container
    extend Dry::Container::Mixin
    register "get_content_from_record", -> model { model.content }
    register "validator",               -> input { Dry::Monads::Success.new input }

    register "role_name", "celebrity"
  end

  Import = Dry::AutoInject Container

  module ClassMethods
    def call(input)
      new.call(input)
    end

    def validate(contract:)
      step :validate_contract

      define_method :validate_contract do |input|
        Common::Ops::Validate.new(validator: contract).(input)
      end
    end

    def use_db_transaction
      prepend Common::DbTransaction
    end

    def save(model_class:)
      step :save

      define_method :save do |input|
        model = model_class.new(input[:attributes])
        if model.save
          Success input.merge(model: model)
        else
          Failure model: model, errors: Errors::AmError.new(model.errors).parse
        end
      end
    end
  end

  module InstanceMethods
    def to_proc
      -> input { self.(input) }
    end
  end

  class Transaction < Module
    def initialize(**options)
      @options = options
    end

    def included(base)
      base.include Dry::Transaction(**@options)
      base.prepend InstanceMethods
      base.extend  ClassMethods
    end
  end
end
