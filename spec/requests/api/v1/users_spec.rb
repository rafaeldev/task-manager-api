require 'rails_helper'

RSpec.describe 'User API', type: :request do
  let!(:user)   { create :user }
  let(:user_id) { user.id }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s
    }
  end

  before { host! 'api.spec.test' }

  describe 'GET /users/:id' do
    before do
      get "/users/#{user_id}", params: {}.to_json, headers: headers
    end

    context 'when users exists' do
      it 'returns the user' do
        expect(json_body[:id]).to eq user_id
      end

      it 'returns status 200' do
        expect(response).to have_http_status 200
      end
    end

    context 'when users does not exists' do
      let(:user_id) { 0 }

      it 'returns status 404' do
        expect(response).to have_http_status 404
      end
    end
  end

  describe 'POST /users' do
    before do
      post '/users', params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request parameters are valid' do
      let(:user_params) { attributes_for :user }

      it 'returns status code 201' do
        expect(response).to have_http_status 201
      end

      it 'returns json data for the created user' do
        expect(json_body[:email]).to eq user_params[:email]
      end
    end

    context 'when the request parameters are invalid' do
      let(:user_params) { attributes_for :user, email: 'invalid' }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'returns json data for the errors' do
        expect(json_body).to have_key :errors
      end
    end
  end

  describe 'PUT /users/:id' do
    before do
      put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request parameters are valid' do
      let(:user_params) { { email: 'foo@doo.com' } }

      it 'returns status code 200' do
        expect(response).to have_http_status 200
      end

      it 'returns json data for the updated user' do
        expect(json_body[:email]).to eq 'foo@doo.com'
      end
    end

    context 'when the request parameters are invalid' do
      let(:user_params) { attributes_for :user, email: 'invalid' }

      it 'returns status code 422' do
        expect(response).to have_http_status 422
      end

      it 'returns json data for the errors' do
        expect(json_body).to have_key :errors
      end
    end
  end

  describe 'DELETE /users/:id' do
    before do
      delete "/users/#{user_id}", params: {}.to_json, headers: headers
    end

    context 'when users exists' do
      it 'removes user from database' do
        expect(User.find_by(id: user_id)).to be_nil
      end

      it 'returns status 204' do
        expect(response).to have_http_status 204
      end
    end

    context 'when users does not exists' do
      let(:user_id) { 0 }

      it 'returns status 404' do
        expect(response).to have_http_status 404
      end
    end
  end
end
