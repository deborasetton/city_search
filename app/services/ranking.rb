class Ranking
  SIMILARITY_WEIGHT = 0.4
  POPULATION_WEIGHT = 0.1
  DISTANCE_WEIGHT   = 0.5

  ALTERNATE_BOOST_PRIMARY   = 1.0
  ALTERNATE_BOOST_ALTERNATE = 0.5
  ALTERNATE_BOOST_HIERARCHY = 0.1

  DISTANCE_BOOST_DECAY = 0.1

  def initialize(matches)
    @matches = matches
  end

  def take(limit)
    sorted_matches.take(limit)
  end

  private

  def sorted_matches
    return @sorted_matches if @sorted_matches

    score_matches!
    @sorted_matches = @matches.sort_by { |m| -m.score }
  end

  def score_matches!
    return if @scored || @matches.empty?

    @matches.each do |search_match|
      search_match.explain_score = {
        similarity: similarity_score(search_match),
        alternate_boost: alternate_boost(search_match),
        population_boost: population_boost(search_match.population),
        distance_boost: search_match.distance && distance_boost(search_match.distance),
        distance: search_match.distance && search_match.distance
      }.compact

      if search_match.distance
        search_match.score =
          SIMILARITY_WEIGHT * similarity_score(search_match) * alternate_boost(search_match) +
          POPULATION_WEIGHT * population_boost(search_match.population) +
          DISTANCE_WEIGHT * distance_boost(search_match.distance)
      else
        search_match.score =
          2 * SIMILARITY_WEIGHT * similarity_score(search_match) * alternate_boost(search_match) +
          2 * POPULATION_WEIGHT * population_boost(search_match.population)
      end
    end

    @scored = true
  end

  def alternate_boost(match)
    case match.matched_field
    when :primary_name   then ALTERNATE_BOOST_PRIMARY
    when :alternate_name then ALTERNATE_BOOST_ALTERNATE
    when :hierarchy      then ALTERNATE_BOOST_HIERARCHY
    else raise "Invalid matched_field: #{match.matched_field.inspect}"
    end
  end

  def similarity_score(match)
    StringSimilarity.call(match.search_vector, match.normalized_query.join)
  end

  def population_boost(population)
    return 1 if (max_population - min_population == 0)
    (population - min_population) / (max_population - min_population).to_f
  end

  def distance_boost(distance)
    distance == 0 ? 1.0 : (1.0 / (distance**DISTANCE_BOOST_DECAY))
  end

  def min_population
    @min_population ||= @matches.map(&:population).min
  end

  def max_population
    @max_population ||= @matches.map(&:population).max
  end

  def min_distance
    @min_distance ||= @matches.map(&:distance).min
  end

  def max_distance
    @max_distance ||= @matches.map(&:distance).max
  end
end
