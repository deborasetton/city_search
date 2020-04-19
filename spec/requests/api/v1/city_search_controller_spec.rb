RSpec.describe API::V1::CitySearchController, type: :request do
  let(:api_client) { create(:api_client) }
  let(:token) { APIClientTokenManager.generate_token(api_client).value }

  let(:headers) do
    json_headers.merge('Authorization' => "Bearer #{token}")
  end

  describe 'GET /api/v1/suggestions' do
    # Most tests below make assertions that depend on the scenario created wih
    # the scenario_london_create.sql file. For a better understanding of the
    # expected behavior of these tests, please see that file.

    before(:all) do
      ActiveRecord::Base.connection.execute(
        File.read('spec/support/data/scenario_london_create.sql'))
    end

    after(:all) do
      ActiveRecord::Base.connection.execute(
        File.read('spec/support/data/scenario_london_destroy.sql'))
    end

    def make_request(params)
      get '/api/v1/suggestions', params: params, headers: headers
    end

    it 'returns an empty array if there are no suggestions' do
      get '/api/v1/suggestions', params: { q: 'wat' }, headers: headers
      expect(response).to have_http_status(:success)
      expect(json['suggestions']).to eq []
    end

    describe 'authentication' do
      context 'when the token is valid' do
        specify do
          get '/api/v1/suggestions', params: { q: 'wat' }, headers: headers
          expect(response).not_to have_http_status(:unauthorized)
        end
      end

      context 'when the token is not valid' do
        specify do
          get '/api/v1/suggestions', params: { q: 'wat' }, headers: json_headers
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe 'response format' do
      specify 'default format' do
        params = { q: 'lon' }
        make_request(params)

        expect(response).to have_http_status(:success)

        expect(json['suggestions'].first.keys).to(
          contain_exactly('name', 'latitude', 'longitude', 'score'))
      end

      specify 'results are sorted by decreasing score' do
        params = { q: 'lond' }
        make_request(params)

        expect(response).to have_http_status(:success)
        expect(json['suggestions'].count).to eq 8

        (0..6).each do |idx|
          expect(json['suggestions'][idx]['score']).to(
            be >= json['suggestions'][idx + 1]['score'])
        end
      end

      specify 'with parameter explain_score=true' do
        params = { q: 'lon', explain_score: 'true' }
        make_request(params)

        expect(response).to have_http_status(:success)

        expect(json['suggestions'].first.keys).to(
          contain_exactly('name', 'latitude', 'longitude', 'score', 'explain_score'))
      end
    end

    describe 'parameter: query' do
      it 'has a minimum length' do
        params = { q: 'lo' }
        make_request(params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].count).to eq 1
        expect(json['errors'][0]['identifier']).to eq 'invalid_query'
      end

      it 'filters results by query' do
        params = { q: 'lond' }
        make_request(params)

        expect(response).to have_http_status(:success)
        expect(json['suggestions'].count).to eq 8
        expect(json['suggestions'][0]['name']).to eq 'London, ON, CA'
        expect(json['suggestions'][1]['name']).to eq 'London, Madison County, OH, US'
        expect(json['suggestions'][2]['name']).to eq 'London, Laurel County, KY, US'
        expect(json['suggestions'][3]['name']).to eq 'Londonderry, Rockingham County, NH, US'
        expect(json['suggestions'][4]['name']).to eq 'Londontowne, Anne Arundel County, MD, US'
        expect(json['suggestions'][5]['name']).to eq 'Alondra Park, Los Angeles County, CA, US'
        expect(json['suggestions'][6]['name']).to eq 'New London, New London County, CT, US'
        expect(json['suggestions'][7]['name']).to eq 'New London, Waupaca County, WI, US'
      end
    end

    describe 'parameters: latitude and longitude' do
      specify 'latitude and longitude must be valid' do
        params = { q: 'lond', latitude: 100, longitude: -200 }
        make_request(params)

        expect(response).to have_http_status(:unprocessable_entity)

        expect(json['errors'].count).to eq 2
        expect(json['errors'][0]['identifier']).to eq 'invalid_latitude'
        expect(json['errors'][1]['identifier']).to eq 'invalid_longitude'
      end

      specify 'location changes relative scores' do
        # Londontowne, Anne Arundel County, MD, US
        params = { q: 'lond', latitude: 37.12898, longitude: -84.08326 }

        make_request(params)

        expect(json['suggestions'].count).to eq 8
        expect(json['suggestions'][0]['name']).to eq 'London, Laurel County, KY, US'
        expect(json['suggestions'][1]['name']).to eq 'London, ON, CA'
        expect(json['suggestions'][2]['name']).to eq 'London, Madison County, OH, US'
        expect(json['suggestions'][3]['name']).to eq 'Londontowne, Anne Arundel County, MD, US'
        expect(json['suggestions'][4]['name']).to eq 'Londonderry, Rockingham County, NH, US'
        expect(json['suggestions'][5]['name']).to eq 'New London, New London County, CT, US'
        expect(json['suggestions'][6]['name']).to eq 'New London, Waupaca County, WI, US'
        expect(json['suggestions'][7]['name']).to eq 'Alondra Park, Los Angeles County, CA, US'
      end
    end

    describe 'parameter: radius_km' do
      specify 'filters results by distance' do
        # Londontowne, Anne Arundel County, MD, US
        params = { q: 'lond', latitude: 37.12898, longitude: -84.08326, radius_km: 700 }

        make_request(params)

        expect(json['suggestions'].count).to eq 4
        expect(json['suggestions'][0]['name']).to eq 'London, Laurel County, KY, US'
        expect(json['suggestions'][1]['name']).to eq 'London, ON, CA'
        expect(json['suggestions'][2]['name']).to eq 'London, Madison County, OH, US'
        expect(json['suggestions'][3]['name']).to eq 'Londontowne, Anne Arundel County, MD, US'
      end
    end

    describe 'parameter: country' do
      it 'filters results by country' do
        params = { q: 'lond', country: 'CA' }

        make_request(params)

        expect(json['suggestions'].count).to eq 1
        expect(json['suggestions'][0]['name']).to eq 'London, ON, CA'
      end
    end

    describe 'parameter: state_or_province' do
      it 'filters results by country' do
        params = { q: 'lond', state_or_province: 'CT' }

        make_request(params)

        expect(json['suggestions'].count).to eq 1
        expect(json['suggestions'][0]['name']).to eq 'New London, New London County, CT, US'
      end
    end

    describe 'parameter: limit' do
      specify 'returns at most the specified number of results' do
        params = { q: 'lond', limit: 3 }

        make_request(params)

        expect(json['suggestions'].count).to eq 3
        expect(json['suggestions'][0]['name']).to eq 'London, ON, CA'
        expect(json['suggestions'][1]['name']).to eq 'London, Madison County, OH, US'
        expect(json['suggestions'][2]['name']).to eq 'London, Laurel County, KY, US'
      end
    end
  end
end
