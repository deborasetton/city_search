# Configuration options for the application.
# Each configuration has a default value which can be altered through
# environment variables.
module Config
  PREFIX = 'CITY_SEARCH'

  # Default number of records that will be returned on the search endpoint.
  DEFAULT_LIMIT = ENV.fetch("#{PREFIX}_DEFAULT_LIMIT", 25)

  # Maximum number of records that can be returned on the search endpoint.
  MAX_LIMIT = ENV.fetch("#{PREFIX}_MAX_LIMIT", 100)

  # Minimum length of the query parameter of the search endpoint.
  MIN_QUERY_SIZE = ENV.fetch("#{PREFIX}_MIN_QUERY_SIZE", 3)

  # Default radius, in km, used to filter records.
  DEFAULT_RADIUS_KM = ENV.fetch("#{PREFIX}_DEFAULT_RADIUS_KM", 20_000)
end
