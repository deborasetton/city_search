class Geoname < ApplicationRecord
  belongs_to :first_level_division
  belongs_to :second_level_division

  has_many :alternate_names

  scope :by_country, -> (country) do
    where(country: country)
  end

  scope :by_state_or_province, -> (state_or_province) do
    joins(:first_level_division).
    where('first_level_divisions.abbreviation = ?', state_or_province)
  end

  scope :by_distance, -> (lat, lng, radius_km) do
    where("#{sanitized_distance(lat, lng)} <= ?", radius_km * 1_000).
    select("#{sanitized_distance(lat, lng)} AS distance")
  end

  scope :by_name, -> (tokens) do
    full_text_query(tokens, 'geonames.ascii_name')
  end

  scope :by_search_vector, -> (tokens) do
    full_text_query(tokens, 'geonames.search_vector')
  end

  scope :by_alternate_name, -> (tokens) do
    clauses = tokens.map do |token|
      "alternate_names.alternate_name LIKE ?"
    end

    wildcards = tokens.map { |token| "%#{token}%" }
    joins(:alternate_names).where(clauses.join('OR '), *wildcards).select('alternate_names.alternate_name AS alternate_name')
  end

  def self.full_text_query(tokens, text_column)
    clauses = tokens.map do |token|
      "#{text_column} ILIKE ?"
    end

    wildcards = tokens.map { |token| "%#{token}%" }
    where(clauses.join('OR '), *wildcards)
  end

  def self.sanitized_distance(lat, lng)
    sanitize_sql_array([
      'ST_DistanceSphere(ST_MakePoint(longitude, latitude), ST_MakePoint(?, ?))',
      lng, lat])
  end

  def display_name
    tokens = [
      name,
      second_level_division&.name,
      first_level_division&.abbreviation,
      country
    ].compact

    tokens.join(', ')
  end
end
