class SearchMatch
  attr_accessor :score, :explain_score

  attr_reader :record, :search_vector, :normalized_query, :matched_field, :distance

  delegate :display_name, :latitude, :longitude, :population, to: :record

  def initialize(normalized_query, search_vector, record, matched_field, distance = nil)
    @normalized_query = normalized_query
    @search_vector = search_vector
    @record = record
    @matched_field = matched_field
    @distance = distance
  end
end
