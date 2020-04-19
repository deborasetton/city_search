RSpec.describe Ranking do
  describe '#call' do
    describe 'scoring factors' do
      describe 'similarity score' do
        specify 'primary > alternate > other' do
          record = double(:record)

          allow(record).to receive(:population) { 0 }
          allow(record).to receive(:distance)

          matches = [
            SearchMatch.new(['QuebecProvince'], 'QuebecProvince', record, :hierarchy),
            SearchMatch.new(['QuebecAlt'], 'QuebecAlt', record, :alternate_name),
            SearchMatch.new(['QuebecCity'], 'QuebecCity', record, :primary_name)
          ]

          results = Ranking.new(matches).take(100)

          expect(results[0].search_vector).to eq 'QuebecCity'
          expect(results[1].search_vector).to eq 'QuebecAlt'
          expect(results[2].search_vector).to eq 'QuebecProvince'
        end
      end

      describe 'population boost' do
        specify 'bigger cities are more relevant' do
          city_big = double('CityBig', population: 1_000_000)
          city_medium = double('CityMedium', population: 600_000)
          city_small = double('CitySmall', population: 70_000)

          matches = [
            SearchMatch.new(['CityBig'], 'CityBig', city_big, :primary_name),
            SearchMatch.new(['CityMedium'], 'CityMedium', city_medium, :primary_name),
            SearchMatch.new(['CitySmall'], 'CitySmall', city_small, :primary_name)
          ]

          results = Ranking.new(matches).take(100)

          expect(results[0].search_vector).to eq 'CityBig'
          expect(results[1].search_vector).to eq 'CityMedium'
          expect(results[2].search_vector).to eq 'CitySmall'
        end
      end

      describe 'distance boost' do
        context 'when distance is provided' do
          specify 'closer cities are more relevant' do
            city_big = double('CityReallyFar', population: 0)
            city_medium = double('CitySoSoFar', population: 0)
            city_small = double('CityClose', population: 0)

            matches = [
              SearchMatch.new(['CityReallyFar'], 'CityReallyFar', city_big, :primary_name, 500),
              SearchMatch.new(['CitySoSoFar'], 'CitySoSoFar', city_medium, :primary_name, 45),
              SearchMatch.new(['CityClose'], 'CityClose', city_small, :primary_name, 5)
            ]

            results = Ranking.new(matches).take(100)

            expect(results[0].search_vector).to eq 'CityClose'
            expect(results[1].search_vector).to eq 'CitySoSoFar'
            expect(results[2].search_vector).to eq 'CityReallyFar'
          end
        end

        context 'when distance is not provided' do
          specify 'distance is not a factor' do
            city_big = double('City_1', population: 0)
            city_medium = double('City_2', population: 0)
            city_small = double('City_3', population: 0)

            matches = [
              SearchMatch.new(['City_1'], 'City_1', city_big, :primary_name),
              SearchMatch.new(['City_2'], 'City_2', city_medium, :primary_name),
              SearchMatch.new(['City_3'], 'City_3', city_small, :primary_name)
            ]

            results = Ranking.new(matches).take(100)

            expect(results[0].search_vector).to eq 'City_1'
            expect(results[1].search_vector).to eq 'City_2'
            expect(results[2].search_vector).to eq 'City_3'
          end
        end
      end
    end

    describe 'factors have different weights' do
      specify 'similarity is more important than population' do
        city_1 = double('City_1', population: 1_000_000)
        city_2 = double('City_2', population: 70_000)

        matches = [
          SearchMatch.new(['SameBog'], 'SomeBigCity', city_1, :primary_name),
          SearchMatch.new(['SmallCityInTheMiddleOfNowhere'], 'SmallCityInTheMiddleOfNowhere', city_2, :primary_name),
        ]

        results = Ranking.new(matches).take(100)

        expect(results[0].search_vector).to eq 'SmallCityInTheMiddleOfNowhere'
        expect(results[1].search_vector).to eq 'SomeBigCity'
      end
    end
  end
end
