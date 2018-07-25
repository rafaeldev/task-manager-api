require 'rails_helper'

RSpec.describe 'User API', type: :request do
  let!(:user)   { create :user }
  let(:user_id) { user.id }

  before { host! 'api.spec.test' }

  describe 'GET /users/:id' do
    before do
      headers = { 'Accept' => 'application/vnd.taskmanager.v1' }

      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when users exists' do
      it 'returns the user' do
        user_response = JSON.parse(response.body)

        expect(user_response['id']).to eq user_id
      end

      it 'returns status 200' do
        expect(response).to have_http_status 200
      end
    end

    context 'when users does not exists' do
      let(:user_id) { 0 }

      it 'returns status 200' do
        expect(response).to have_http_status 404
      end
    end
  end
end
