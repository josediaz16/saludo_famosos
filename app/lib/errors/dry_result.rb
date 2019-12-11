module Errors

  ErrorCodes = {
    filled?: "blank",
    key?: "blank"
  }

  PredicateHandlers = {
    key?: nil
  }

  class DryResult
    attr_reader :result, :new_error, :object_class

    def initialize(result, object_class)
      @result = result
      @new_error = Errors::Simple.lazy.(object_class)
    end

    def parse
      result.errors.each_with_object([]) do |message, array|
        predicate = message.predicate || message.meta[:code]
        value = message.input || message.meta[:input]

        array << new_error.(
          message.path.join("."),
          ErrorCodes.fetch(predicate, predicate.to_s),
          message.text,
          PredicateHandlers.fetch(predicate, value)
        )
      end
    end

  end
end
