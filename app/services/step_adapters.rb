class StepAdapters < Dry::Transaction::StepAdapters
  register :validate, -> _step_ , options, *args do
    contract = options[:contract]

    input = args.flatten.last.to_h
    result = contract.(input)

    if result.success?
      Dry::Monads::Success input
    else
      Dry::Monads::Failure attributes: input, errors: Errors::DryResult.new(result, contract.object_class).parse
    end
  end
end
