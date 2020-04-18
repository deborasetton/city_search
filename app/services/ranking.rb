class Ranking
  SIMILARITY_WEIGHT = 0.4
  POPULATION_WEIGHT = 0.1
  DISTANCE_WEIGHT = 0.5

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

    if @matches.first.distance
      @matches.each do |search_match|
        search_match.explain_score = {
          similarity: search_match.similarity_score,
          alternate_penalty: alternate_penalty(search_match),
          population_boost: population_boost(search_match.population),
          distance_boost: distance_boost(search_match.distance),
          distance: search_match.distance / 1_000
        }

        search_match.score =
          SIMILARITY_WEIGHT * search_match.similarity_score * alternate_penalty(search_match) +
          POPULATION_WEIGHT * population_boost(search_match.population) +
          DISTANCE_WEIGHT * distance_boost(search_match.distance)
      end
    else
      @matches.each do |search_match|
        puts search_match.search_vector

        search_match.explain_score = {
          similarity: search_match.similarity_score,
          alternate_penalty: alternate_penalty(search_match),
          population_boost: population_boost(search_match.population)
        }

        search_match.score =
          2 * SIMILARITY_WEIGHT * search_match.similarity_score * alternate_penalty(search_match) +
          2 * POPULATION_WEIGHT * population_boost(search_match.population)
      end
    end

    @scored = true
  end

  def alternate_penalty(match)
    case match.matched_field
    when :primary_name then 1
    when :secondary_name then 0.5
    when :hierarchy then 0.1
    else raise "Invalid: #{match.matched_field.inspect}"
    end
  end

  def population_boost(population)
    return 1 if (max_population - min_population == 0)
    (population - min_population) / (max_population - min_population).to_f
  end

  def distance_boost(distance)
    distance == 0 ? 1 : 1 / ((distance.to_f)**0.1)
    #(distance - min_distance) / (max_distance - min_distance).to_f
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
