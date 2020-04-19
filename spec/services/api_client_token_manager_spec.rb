RSpec.describe APIClientTokenManager do
  let(:api_client) { create(:api_client) }

  describe '.generate_token' do
    context 'when expires_at is not provided' do
      it 'creates a token with the default expiration date' do
        token = described_class.generate_token(api_client)
        expect(token.value).to be_a(String)
        expect(token.expires_at.to_date).to be > Time.now
      end
    end
  end

  describe '.find_api_client' do
    context 'when the token is valid' do
      let(:token) { described_class.generate_token(api_client).value }

      it 'returns the api_client' do
        expect(described_class.find_api_client(token)).to eq api_client
      end
    end

    context 'when the token is not valid' do
      it 'does not return an api_client' do
        expect(described_class.find_api_client('not-valid')).to be_nil
      end
    end

    context 'when the token is expired' do
      let(:expired_token) { described_class.generate_token(api_client, 1.month.ago).value }

      it 'does not return an api_client' do
        expect(described_class.find_api_client(expired_token)).to be_nil
      end
    end
  end
end
