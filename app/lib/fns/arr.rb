module Fns
  module Arr

    Sum = -> fn, array { array.sum(&fn) }.curry

    # Takes an array of values and sums the integer value of its elements
    SumIntegers = Sum.(:to_i)

    # Takes an array of arrays of numbers and returns the sum.
    SumArrays = :flatten | SumIntegers

    # Takes an array of hashes and group the elements by a key
    GroupByKey = -> key, array { array.group_by &(Fns::Fetch.(key) | :to_sym.to_proc) }.curry

    # Takes an array of hashes and group the elements by a key, and transform
    # values by getting the first element.
    GroupFlat = -> key { GroupByKey.(key) | Fns::TransformValues.(:first) }

    Concat = -> arr_1, arr_2 { arr_1 + arr_2 }.curry

    RenameEach = -> new_keys, array do
      array.map &Fns::H::RenameKeys.(new_keys)
    end.curry

    # Takes an array of hashes and sort by two criteries first key_a then key_b
    SortAscDesc = -> key_a, key_b, prev, nex do
      prev[key_a].eql?(nex[key_a]) ? prev[key_b] <=> nex[key_b] : nex[key_a] <=> prev[key_a]
    end.curry

    FindMapFirst = -> check_fn, map_fn, arr do
      arr.inject(nil) do |final_value, item|
        result = map_fn.(item)
        return result if check_fn.(result)
      end
    end.curry

    FindFirstPresent = FindMapFirst.(:present?.to_proc)

  end
end
