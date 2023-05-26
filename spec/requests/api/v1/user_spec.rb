require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { user: { email: 'john@example.com', password: 'password' } } }

      it 'creates a new user' do
        expect {
          post api_v1_users_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'returns a JSON response with status 201' do
        post api_v1_users_path, params: valid_params
        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to include('id', 'email')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user: {email: 'invalid_email', password: 'short' } } }

      it 'does not create a new user' do
        expect {
          post api_v1_users_path, params: invalid_params
        }.not_to change(User, :count)
      end

      it 'returns a JSON response with status 400 and error details' do
        post api_v1_users_path, params: invalid_params
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to include('email', 'password')
      end
    end
  end
end