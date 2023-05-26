require 'rails_helper'

RSpec.describe "Api::V1::Urls", type: :request do
  let(:user) { User.create(email: 'example@nami.ai', password: 'sdf12345678') }
  let(:payload) { { user_id: user.id } }
  let(:jwt_token) { generate_jwt_token(payload) }
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{jwt_token}"
    }
  end
  describe 'POST /api/v1/urls/encode' do
    context 'when the JWT is provided right and Url is valid' do
      it 'encode a url' do
        post encode_api_v1_urls_path, params: { url: 'https://codesubmit.io/library/react' }.to_json, headers: headers
        expect(response.body).to include('shortened')

        parsed_response = JSON.parse(response.body)
        shortened_url = parsed_response['shortened']
        expect(shortened_url).not_to be_nil
        expect(response).to have_http_status(:ok)
      end
    end
    context 'when the JSW token is not provided or is wrong' do
      let(:wrong_jwt_token) {'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE2ODU0MzQyODR9.UuzTXLa7'} 
      it 'return error for Nil JSON web token' do
        post encode_api_v1_urls_path, params: { url: 'https://codesubmit.io/library/react' }.to_json, headers: {'Content-Type' => 'application/json'}
        
        expect(response).to have_http_status(400)
        expect(response.body).to eq({error: 'Nil JSON web token'}.to_json)
      end
      it 'return error Signature verification failed for wrong JWT ' do
        
        post encode_api_v1_urls_path, params: { url: 'https://codesubmit.io/library/react' }.to_json, headers: {'Content-Type' => 'application/json','Authorization' => "Bearer #{wrong_jwt_token}"}
       
        expect(response).to have_http_status(400)
        expect(response.body).to eq({error: 'Signature verification failed'}.to_json)
      end
    end
    context 'with an invalid URL' do
      let(:invalid_url) { 'invalid_url' }

      it 'returns unprocessable entity status and error details' do
        post encode_api_v1_urls_path, params: { url: invalid_url }.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('error')

        parsed_response = JSON.parse(response.body)
        error = parsed_response['error']

        expect(error).to include('Invalid URL')
      end
    end
  end 

  describe 'POST /api/v1/urls/decode' do
    context 'when the requested URL exists' do
      let!(:exist_url) { Url.create(shortened: '9c38JnA', original: 'https://codesubmit.io/library/react', user_id: 1) }
      it 'decode a shortened url' do
        
        post decode_api_v1_urls_path, params: { shortened: exist_url.shortened}.to_json, headers: headers

        expect(response.body).to eq({url: exist_url.original}.to_json)
        expect(response).to have_http_status(:ok)
      end
    end
    context 'when the requested URL does not exist' do
      it 'returns an error' do
        post decode_api_v1_urls_path, params: { shortened: 'nonexistent' }.to_json, headers: headers

        expect(response.body).to eq({ error: 'URL not found' }.to_json)
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when the requested URL is not valid' do
      it 'returns an error' do
        post decode_api_v1_urls_path, params: { shortened: 'nonexistent' }.to_json, headers: headers

        expect(response.body).to eq({ error: 'URL not found' }.to_json)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
