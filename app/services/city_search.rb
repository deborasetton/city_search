class CitySearch
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    scope = set_fields(Geoname.all)
    scope = set_filters(scope)

    tokens = QueryTokenizer.call(params[:query])

    matches = {}

    scope.by_name(tokens).each do |record|
      next if matches[record.id]
      matches[record.id] = SearchMatch.new(tokens, record.ascii_name, record, :primary_name)
    end

    scope.by_alternate_name(tokens).each do |record|
      next if matches[record.id]
      matches[record.id] = SearchMatch.new(tokens, record.alternate_name, record, :alternate_name)
    end

    scope.by_search_vector(tokens).each do |record|
      next if matches[record.id]
      matches[record.id] = SearchMatch.new(tokens, record.search_vector, record, :hierarchy)
    end

    Ranking.new(matches.values).take(params[:limit] || Config::DEFAULT_LIMIT)
  end

  def set_fields(scope)
    scope.select(
      :ascii_name,
      :country,
      :first_level_division_id,
      :id,
      :latitude,
      :longitude,
      :name,
      :population,
      :search_vector,
      :second_level_division_id).includes(:first_level_division, :second_level_division)
  end

  def set_filters(scope)
    if params[:country]
      scope = scope.by_country(params[:country])
    end

    if params[:state_or_province]
      scope = scope.by_state_or_province(params[:state_or_province])
    end

    if params[:latitude] && params[:longitude]
      scope = scope.by_distance(
        params[:latitude],
        params[:longitude],
        params[:radius_km] || Config::DEFAULT_RADIUS_KM)
    else
      scope = scope.select('NULL AS distance')
    end

    scope
  end
end
