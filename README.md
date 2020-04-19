# City Search API

This repository contains the source code for the City Search API.

A live demo is available at: https://co-city-search.herokuapp.com/

## General description

This is a Ruby on Rails API application which uses PostgreSQL as database
(it requires the PostGIS and citext extensions).

The API contains a single endpoint, `suggestions`, which finds and scores
cities and returns the results in decreasing order of score.

For a description of the API, please see the
[API documentation](https://app.swaggerhub.com/apis-docs/setton/city_search/0.0.1).

## Scoring algorithm overview

After an initial selection of candidates is performed on the database (see
the next section for an overview of how candidates are selected), each candidate
is assigned a relative score between 0 and 1, which is the weighted average of
the following sub-scores:

1) **String similarity to the search text:** the closer the search text matches
the candidates's "name", the higher this score will be. For example, if the search text
is "Mont", "Montréal" will score higher than  "Sainte-Anne-des-Monts".

    - The candidate's name considered for matching can be:
        - the official name of that location;
        - an alternate name; or
        - a search vector string which includes the county
      and state/province names
    - Comparisons are case-insenstive
    - Comparisons are performed using the ASCII-equivalent of a term. For example, "Montréal" would be converted to "Montreal" prior to matching
    - Currently, the similarity score is given by the [Jaro-Winkler distance](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance)
      between the strings. More sophisticated methods for comparison could be
      used to improve results, and this is listed as a potential area of improvement
      (see section "Ideas for improvements" below)

2) **Matched field:** as noted above, a match can occur between the search
term and 3 possible fields: official name, alternate name or search vector. Each
of these fields is considered less relevant than the previous. For example: if
the search term is "Québec", then "Québec, Québec, CA" will be considered more
relevant than "Montréal, Québec, CA", because a match in the primary location name
is more relevant than a match in the province name.

3) **Population:** if all else is equal, larger cities are considered more relevant.

4) **Distance:** if a location is provided, candidates closest to the given location
will be considered more relevant.

### Initial selection of candidates

In order to avoid having to run the scoring algorithm for all possible locations, an initial selection is performed on the database using 2 filters:

1) Only records whose name contains the search term as a substring will be returned. If the search term contains multiple words (space- or comma-delimited), at least one of the search term words has to be a substring of the record's name.
    - Examples:
        - "Mont" matches "Montréal" and "South El Monte", but does not match "Québec".
        - "Las" matches "Las Vegas", "Las Flores" and "Dallas".
        - "Las Vegas" matches "Las Vegas", but does not match "Las Flores".

2) If latitude and longitude are specified, only records which are within a specified radius will be returned. By default, this radius is large enough that it won't filter out any records, but this can be changed through a parameter.

## How to run

The only dependencies are `docker` and `docker-compose`.

```bash
# Rails API
cp .env.example .env
docker-compose build api

# This command will print you development API token. You will need this token
# to issue API requests.
docker-compose run --rm api bash -c 'bin/setup'

# This will start the Rails server on port 3000.
# You can access the application on http://localhost:3000/api/v1/suggestions?q=lon
docker-compose up
```

### Run specs (setup must be run first!)

```bash
docker-compose run --rm api bash -c 'bundle exec rspec'
```

### Ideas for improvements

This is a non-exhaustive list of improvements that could be made.

- Use a better string similarity algorithm. This could be a combination of different algorithms, such as [Jaro-Winkler distance](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance) and [Jaccard index](https://en.wikipedia.org/wiki/Jaccard_index)
- Use some sort of word stemming to give less weight to common suffixes (e.g., "ville" in "Oakville", "Louiseville")
- Consider the "popularity" of a city in the scoring algorithm. This could be done if we gathered information about "correct matches" and improved the scoring algorithm over time to give more relevance to cities that are most commonly searched for (which are not necessarily the largest cities)
- Add rate limiting to the API
