module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body) if response.body.present?
    end

    def json_headers
      {
        'Accept' => 'application/json'
      }
    end
  end
end
