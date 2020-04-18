module API
  class APIController < ApplicationController
    before_action :authenticate!
    before_action :set_default_response_format

    APIError = Struct.new(:status, :title, :detail)

    protected

    def set_default_response_format
      request.format = :json unless params[:format]
    end

    def authenticate!
      # TODO: implement
      return

      if request.headers['Authorization']
        jwt_token = request.headers['Authorization'].remove('Bearer ')
        @current_user = APIClientTokenManager.find_api_client(jwt_token)
      end

      render 'unauthorized' unless @current_user
    end
  end
end
