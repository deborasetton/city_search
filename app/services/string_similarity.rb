class StringSimilarity
  def self.call(str1, str2)
    JaroWinkler.distance(str1, str2, ignore_case: true)
  end
end
