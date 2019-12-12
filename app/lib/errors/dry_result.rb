module Errors

  ErrorCodes = {
    filled?: "blank",
    key?: "blank"
  }

  PredicateHandlers = {
    key?: nil
  }

  BlackListedValues = /password/

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
        field = message.path.join(".")

        array << new_error.(
          field,
          ErrorCodes.fetch(predicate, predicate.to_s),
          message.text,
          PredicateHandlers.fetch(predicate, get_value(field, value))
        )
      end
    end

    def get_value(field, value)
      if field.match(BlackListedValues).present?
        ""
      else
        value
      end
    end

  end
end
