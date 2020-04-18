module API
  module V1
    class CitySearchController < APIController
      MIN_QUERY_SIZE = 3

      def suggestions
        if params[:q].blank? || params[:q].size < MIN_QUERY_SIZE
          @error = APIError.new(422, 'Invalid query', "Query length must be greater than #{MIN_QUERY_SIZE - 1}")
          render :error
          return
        end

        @suggestions = CitySearch.call(
          {
            query: params[:q],
            latitude: params[:latitude],
            longitude: params[:longitude],
            country: params[:country],
            state: params[:state]
          }.compact)

        render 'suggestions'
      end
    end
  end
end
