# This class envolves an ActiveModel::Errors object to parse the
# errors to a common base structure.

class Errors::AmError
  attr_reader :errors, :new_error

  def initialize(errors, &block)
    @errors = errors
    @block = block
    @new_error = Errors::Simple.lazy.(object_class)
  end

  def parse
    errors.messages.each_with_object([]) do |(field, messages), array|

      messages.each_with_index do |message, index|
        code = errors.details[field][index][:error]
        array << new_error.(field.to_s, code.to_s, message, get_value(field), &@block)
      end
    end
  end

  private

  def get_value(field)
    field.to_s.split(".").inject(base, :send)
  end

  def object_class
    if base.present?
      base.class.to_s.underscore
    else
      "generic"
    end
  end

  def base
    @base ||= errors.instance_variable_get("@base")
  end
end
