require 'rails_helper'
require 'support/controllers_helper'

RSpec.describe V1::AuthenticationController do
  let!(:admin) {FactoryBot.create(:user, profile: Profile.first)}
  describe 'POST #authenticate' do
    describe 'with correct credentials' do
      let!(:authenticate) {post :authenticate, params: {email: admin.email, password: admin.password}}

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns JWT' do
        expect(JSON.parse(response.body).keys).to match(%w[user auth_token])
      end
    end

    describe 'with incorrect credentials' do
      let!(:authenticate) {post :authenticate, params: {email: admin.email, password: 'thewrongpassword' }}

      it 'returns http success' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns credentials error' do
        expect(JSON.parse(response.body).keys).to match(%w[error])
      end
    end

  end
end