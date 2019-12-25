module Fns
  module Monads
    extend Dry::Monads[:result]

    Right = -> input { Success input }
    Left =  -> input { Failure input }
  end
end
