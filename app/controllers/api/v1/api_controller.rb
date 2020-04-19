module API
  module V1
    class APIController < ApplicationController
      before_action :authenticate!
      before_action :set_default_response_format

      APIError = Struct.new(:status, :title, :detail)

      protected

      def set_default_response_format
        request.format = :json unless params[:format]
      end

      def authenticate!
        if request.headers['Authorization']
          jwt_token = request.headers['Authorization'].remove('Bearer ')
          @current_user = APIClientTokenManager.find_api_client(jwt_token)
        elsif params[:t]
          @current_user = APIClientTokenManager.find_api_client(params[:t])
        end

        unless @current_user
          add_error(APIError.new(401, 'Unauthorized', 'Missing or invalid authentication token'))
          render 'api/v1/errors'
        end
      end

      def add_api_error(error_identifier, **interpolation_args)
        error = APIError.new(
          I18n.t("api.v1.errors.#{error_identifier}.status"),
          I18n.t("api.v1.errors.#{error_identifier}.title"),
          I18n.t("api.v1.errors.#{error_identifier}.description", **interpolation_args))

        add_error(error)
      end

      def add_error(error)
        @errors ||= []
        @errors << error
      end

      def has_errors?
        @errors && @errors.any?
      end
    end
  end
end
