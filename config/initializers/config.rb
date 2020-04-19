# Configuration options for the application.
# Each configuration has a default value which can be alteres through
# environment variables.
module Config
  PREFIX = 'CITY_SEARCH'

  MAX_LIMIT = ENV.fetch("#{PREFIX}_MAX_LIMIT", 100)

  MIN_QUERY_SIZE = ENV.fetch("#{PREFIX}_MIN_QUERY_SIZE", 3)

  DEFAULT_RADIUS_KM = ENV.fetch("#{PREFIX}_DEFAULT_RADIUS_KM", 20_000)

  DEFAULT_LIMIT = ENV.fetch("#{PREFIX}_DEFAULT_LIMIT", 25)
end
