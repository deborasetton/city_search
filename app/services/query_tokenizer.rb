class QueryTokenizer
  DELIMITERS = [',', ' ']

  # 'jacksonville,florida us'
  def self.call(query)
    tokens = I18n.transliterate(query).split(Regexp.union(DELIMITERS))
  end
end
