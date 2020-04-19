module Config
  PREFIX = 'CITY_SEARCH'

  MIN_QUERY_SIZE = ENV.fetch("#{PREFIX}_MIN_QUERY_SIZE", 3)

  DEFAULT_RADIUS_KM = ENV.fetch("#{PREFIX}_DEFAULT_RADIUS_KM", 20_000)

  DEFAULT_LIMIT = ENV.fetch("#{PREFIX}_DEFAULT_LIMIT", 25)
end
