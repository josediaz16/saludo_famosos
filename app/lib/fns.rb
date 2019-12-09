module Fns

  #### GENERAL
  # A function that literally does nothing
  DoNothing = -> _ {}

  # A function that returns the same input.
  ReturnSelf = -> input { input }

  Fetch = -> key, hash { hash[key] }.curry

  Map = -> fn, collection { collection.map(&fn) }.curry

  #### NUMBERS
  # A function that divides two numbers, returns float
  Divide  = -> a, b do
    CustomMonads.Zero(b)
      .fmap { |value| (a.to_f / value.to_f) }
      .value_or(0)
  end

  # A Util function to divide several numbers with the same divisor
  DivideB = -> b, a { Divide.(a, b) }.curry

  Round = -> number, input { input.round(number) }.curry

  # Takes an input number and returns its percentage value
  Percentage = -> round_num, input { (input * 100).round(round_num) }.curry

  # Takes two input number and returns its relation percentage value
  Relation = Divide | Percentage.(1)

  Camelize = -> key { key.camelize(:lower) }


  #### FUNCTIONS
  # Takes two functions that receive the same input and sum the results with a third function.
  SumOutput = -> fn_a, fn_b, sum_fn, input do
    sum_fn.call fn_a.(input), fn_b.(input)
  end.curry

  # Takes two functions that receive the same input and divides their result
  DivideFns = -> fn_a, fn_b, input do
    Divide.call fn_a.(input), fn_b.(input)
  end.curry

  # Takes a function and a hash and returns a transform curried function.
  TransformValues = -> fn, hash { hash.transform_values(&fn) }.curry

  # Takes a function and a hash and returns a transform curried function.
  TransformKeys = -> fn, hash { hash.transform_keys(&fn) }.curry

  SplatArgs = -> fn, args { fn.(*args) }.curry

  #### Monads

  MonadResult = -> result do
    result.success? ? result.success : result.failure
  end
end
