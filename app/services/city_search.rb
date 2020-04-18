class CitySearch
  DEFAULT_RADIUS_KM = 10_000_000 # km
  DEFAULT_LIMIT = 25

  def self.call(params)
    country = params[:country]
    state = params[:state]

    scope = Geoname.all

    if params[:country]
      scope = scope.where(country: params[:country])
    end

    if params[:state_or_province]
      scope = scope.where(state_or_province: params[:state_or_province])
    end

    if params[:latitude] && params[:longitude]
      scope = scope.by_distance(params[:latitude], params[:longitude], params[:radius_km] || DEFAULT_RADIUS_KM)
      scope = scope.select("ST_Distance_Sphere(ST_MakePoint(longitude, latitude), ST_MakePoint(#{params[:longitude]}, #{params[:latitude]})) as distance")
    else
      scope = scope.select("NULL AS distance")
    end

    scope = scope.select(:id, :name, :longitude, :latitude, :population, :ascii_name, :search_vector, :admin1_code, :admin2_code, :country)

    tokens = QueryTokenizer.call(params[:query])

    matches_map = {}

    name_matches = scope.by_name(tokens).map do |record|
      next if matches_map[record.id]
      matches_map[record.id] = true
      SearchMatch.new(tokens, record.ascii_name, record, :primary_name, record.distance)
    end

    alternate_name_matches = scope.by_alternate_name(tokens).map do |record|
      next if matches_map[record.id]
      matches_map[record.id] = true
      SearchMatch.new(tokens, record.alternate_name, record, :secondary_name, record.distance)
    end

    search_vector_matches = scope.by_search_vector(tokens).map do |record|
      next if matches_map[record.id]
      matches_map[record.id] = true
      SearchMatch.new(tokens, record.search_vector, record, :hierarchy, record.distance)
    end

    search_matches = (name_matches + alternate_name_matches + search_vector_matches).compact

    Ranking.new(search_matches).take(params[:limit] || DEFAULT_LIMIT)
  end
end
