require 'rails_helper'

RSpec.describe Api::Auth::AuthenticationController, type: :request do
  describe 'POST #login' do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      it 'returns a JWT token' do
        post api_auth_login_path, params: { email: user.email, password: user.password }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['token']).not_to be_nil
      end
    end

    context 'with invalid credentials' do
      it 'returns an error' do
        post api_auth_login_path, params: { email: user.email, password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end
end