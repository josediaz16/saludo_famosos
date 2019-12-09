module Fns
  module Str
    Split = -> sep, str { str.split(sep) }.curry

    CountMatchingWords = -> ref_string, words do
      words
        .select { |word| ref_string.match(word).present? }
        .count
    end.curry

    MatchPercentage = -> string_a, string_b do
      words_b = string_b.downcase.split(" ")

      matching_words = CountMatchingWords.(string_a.downcase, words_b)
      Fns::Relation.(matching_words, words_b.count)
    end

    PascalUnder = -> str do
      str
        .gsub(/\s+/, "_")
        .gsub(/(?<=^|_)[a-z]/, &:capitalize)
        .gsub(/(?<=[a-z])([A-Z])/, '_\1')
    end


  end
end
