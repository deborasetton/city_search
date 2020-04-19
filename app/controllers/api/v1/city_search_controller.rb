module API
  module V1
    class CitySearchController < APIController
      before_action :validate_params

      # A coordinate point is invalid if it contains anything other than
      # digits, a decimal point ('.') and a minus sign ('-').
      INVALID_COORDINATE_REGEX = /[^\-\.\d]/

      def suggestions
        return if has_errors?

        search_params = {
          query: params[:q],
          latitude: params[:latitude] && params[:latitude].to_f,
          longitude: params[:longitude] && params[:longitude].to_f,
          country: params[:country],
          state: params[:state]
        }.compact

        @suggestions = CitySearch.new(search_params).call
      end

      private

      def validate_params
        if params[:q].blank? || params[:q].size < Config::MIN_QUERY_SIZE
          add_api_error(:invalid_query, min_length: Config::MIN_QUERY_SIZE)
        end

        if params[:latitude] && (
            params[:latitude] =~ INVALID_COORDINATE_REGEX ||
            params[:latitude].to_f.abs > 90)

          add_api_error(:invalid_latitude)
        end

        if params[:longitude] && (
            params[:longitude] =~ INVALID_COORDINATE_REGEX ||
            params[:longitude].to_f.abs > 180)

          add_api_error(:invalid_longitude)
        end

        render 'api/v1/errors' if has_errors?
      end
    end
  end
end
