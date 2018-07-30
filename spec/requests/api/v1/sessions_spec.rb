require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  let!(:user) { create :user }

  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s
    }
  end

  before { host! 'api.spec.test' }

  describe 'POST /sessions' do
    before  do
      post '/sessions', params: { session: credentials }.to_json, headers: headers
    end

    context 'when credentials are correct' do
      let(:credentials) { { email: user.email, password: '123123' } }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'returns the json data for user with auth token' do
        user.reload

        expect(json_body[:auth_token]).to eq user.auth_token
      end
    end

    context 'when credentials are incorrect' do
      let(:credentials) { { email: user.email, password: 'invalid' } }

      it 'returns status code 401' do
        expect(response).to have_http_status 401
      end

      it 'returns the json data for user with auth token' do
        expect(json_body).to have_key :errors
      end
    end
  end
end
