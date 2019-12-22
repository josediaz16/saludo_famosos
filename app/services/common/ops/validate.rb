require 'dry/transaction/operation'

module Common
  module Ops
    class Validate
      include Dry::Transaction::Operation
      include AppConfig::Import["validator"]

      def call(input)
        result = validator.(input)

        if result.success?
          Success input
        else
          Failure attributes: input, errors: Errors::DryResult.new(result, validator.object_class).parse
        end
      end
    end
  end
end
