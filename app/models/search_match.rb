class SearchMatch
  # SearchMatch = Struct.new(:record, :similarity_score, :is_alternate, :population, :distance)

  attr_reader :record, :search_vector, :normalized_query, :matched_field
  attr_accessor :score, :explain_score

  delegate :display_name, :population, :latitude, :longitude, to: :record

  def initialize(normalized_query, search_vector, record, matched_field, distance)
    @normalized_query = normalized_query
    @search_vector = search_vector
    @record = record
    @matched_field = matched_field
    @distance = distance
  end

  def distance
    record.distance
  end

  def similarity_score
    JaroWinkler.distance(search_vector, normalized_query.join, ignore_case: true)
  end
end
