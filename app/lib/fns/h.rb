module Fns
  #### HASHES
  module H
    # Takes two hashes and returs the sum of their elements
    SumHashes = -> collection_a, collection_b do
      collection_a.merge(collection_b) do |k, a, b|
        a + b
      end
    end.curry

    # Takes a hash and return the sum of its values.
    SumHashValues = :values | Fns::Arr::SumIntegers

    AddTotalToHash = -> hash do
      hash.merge total: SumHashValues.(hash)
    end

    SymAttr = :attributes | :symbolize_keys.to_proc

    RenameKey = -> old_key, new_key, block, hash do
      value = hash.delete(old_key) if hash.key?(old_key)

      hash[new_key] = block.call(value)
      hash
    end.curry

    RenameKeys = -> new_keys, hash do
      new_keys.reduce(hash) do |original_hash, (old_key, new_key)|
        RenameKey.(old_key, new_key, Fns::ReturnSelf, original_hash)
      end
    end.curry

    CamelizeKeys = :to_s | Fns::Camelize | :to_sym

  end
end
