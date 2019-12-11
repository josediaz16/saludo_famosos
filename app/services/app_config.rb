module AppConfig
  module ClassMethods
    def call(input)
      new.call(input)
    end

    def validate(contract:)
      step :validate_contract

      define_method :validate_contract do |input|
        result = contract.(input)

        if result.success?
          Dry::Monads::Success input
        else
          Dry::Monads::Failure attributes: input, errors: Errors::DryResult.new(result, contract.object_class).parse
        end
      end
    end

    def save(model_class:)
      step :save

      define_method :save do |input|
        model = model_class.new(input)
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
