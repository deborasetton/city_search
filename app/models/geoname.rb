class Geoname < ApplicationRecord
  has_many :alternate_names

  scope :by_distance, -> (lat, lng, radius_km) do
    where("ST_Distance_Sphere(ST_MakePoint(longitude, latitude), ST_MakePoint(?, ?)) <= ?", lng, lat, radius_km * 1_000)
  end

  scope :by_name, -> (tokens) do
    clauses = tokens.map do |token|
      "ascii_name ILIKE ?"
    end

    wildcards = tokens.map { |token| "%#{token}%" }
    where(clauses.join('OR '), *wildcards)
  end

  scope :by_search_vector, -> (tokens) do
    clauses = tokens.map do |token|
      "search_vector LIKE ?"
    end

    wildcards = tokens.map { |token| "%#{token}%" }
    where(clauses.join('OR '), *wildcards)
  end

  scope :by_alternate_name, -> (tokens) do
    clauses = tokens.map do |token|
      "alternate_names.search_vector LIKE ?"
    end

    wildcards = tokens.map { |token| "%#{token}%" }
    joins(:alternate_names).where(clauses.join('OR '), *wildcards).select('alternate_names.alternate_name AS alternate_name')
  end

  def admin1_code_object
    if admin1_code
      Admin1Code.where(identifier: "#{country}.#{admin1_code}").first
    end
  end

  def county
    if admin1_code && admin2_code
      Admin2Code.where(identifier: "#{country}.#{admin1_code}.#{admin2_code}").first
    end
  end

  def display_name
    #search_vector
    "#{name}, #{county&.name}, #{admin1_code_object&.name}, #{country}"
  end
end
