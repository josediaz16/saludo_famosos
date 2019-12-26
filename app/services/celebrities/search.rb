module Celebrities
  ItemsByEnv = {
    "development" => 8,
    "production" => 8,
    "test" => 4
  }

  DefaultOptions = {
    fields: ["username", "name", "country"],
    match: :word_start,
    load: false,
    misspellings: {below: 5},
    suggest: true,
    per_page: ItemsByEnv[Jets.env]
  }

  Search = -> query, options = Hash.new, &block do
    searchkick = Celebrity.search(query, DefaultOptions.merge(options.symbolize_keys))

    {
      results: JsonResults.(searchkick, &block),
      pages: searchkick.total_pages,
      total: searchkick.total_count,
      suggestions: FilterSuggestions.(searchkick.suggestions, query)
    }
  end

  JsonResults = -> results, &block do
    results
      .as_json
      .map { |result| result.except("_index", "_type", "_id") }
      .map(&block)
  end

  FilterSuggestions = -> suggestions, query do
    suggestions.reject do |suggestion|
      query.match(Regexp.new(suggestion, Regexp::IGNORECASE)).present? || suggestion.match(Regexp.new(query, Regexp::IGNORECASE)).present?
    end
  end
end
