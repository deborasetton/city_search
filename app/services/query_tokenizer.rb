class QueryTokenizer
  DELIMITERS = [',', ' ']
  DELIMITERS_REGEX = Regexp.union(DELIMITERS)

  def self.call(query)
    tokens = I18n.
      transliterate(query, nil).
      split(DELIMITERS_REGEX).
      select(&:present?)
  end
end
