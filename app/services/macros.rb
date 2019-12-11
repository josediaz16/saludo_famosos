module Macros
  module InstanceMethods
  end

  module ClassMethods
    include Dry::Monads[:result]

    # validate macro
    # Includes Building a contract and calling the validate process.
    # It will set a default semantic as :broken_contrac if fails
    # to easily pattern match it at the end of the process.
    def validate(constant:)
      step Trailblazer::Operation::Contract::Build(constant: constant)

      step(
        Trailblazer::Operation::Contract::Validate(),
        Output(:failure) => End(:broken_contract)
      )
    end

    # validate macro
    # Includes creating a new Model object and actually persisting.
    # It will set a default semantic as :model_created if success
    # to easily pattern match it at the end of the process.
    def persist(*args, model:)
      step Trailblazer::Operation::Model(model, :new)
      step -> options, ** { options[:"contract.model"] = options[:model] }

      step(
        Trailblazer::Operation::Contract.Persist(name: :model),
        Output(:success) => End(:model_created)
      )
    end

    def call(*args, _standard_: true, **kwargs)
      result = super(*args, params: kwargs)
      return result if not _standard_

      semantic = result.event.to_h[:semantic]

      if result.success?
        standard_right_track(semantic, result)
      else
        standard_left_track(semantic, result)
      end
    end

    def standard_right_track(semantic, result)
      case semantic
      when :model_created
        Success result["model"]
      else
        Success result.to_h
      end
    end

    def standard_left_track(semantic, result)
      case semantic
      when :broken_contract
        Failure errors: result["result.contract.default"].errors.to_h
      else
        Failure errors: result.to_h
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
