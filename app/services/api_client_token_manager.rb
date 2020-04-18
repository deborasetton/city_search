class APIClientTokenManager
  class << self
    def generate_token(user, expires_at = nil)
      expires_at ||= default_expires_at
      payload = { id: user.id, expires_at: expires_at }
      token = JWT.encode(payload, ENV.fetch('JWT_SECRET'), 'HS256')
      APIClientToken.new(token, expires_at)
    end

    def find_api_client(token)
      begin
        decoded = JWT.decode(token, ENV.fetch('JWT_SECRET'), true, algorithm: 'HS256')
        payload = decoded.first
      rescue JWT::DecodeError
        return
      end

      APIClient.find(payload['id']) if payload['expires_at'].to_datetime >= Time.current
    end

    private

    def default_expires_at
      1.month.from_now
    end
  end
end
