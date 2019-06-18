require 'rails_helper'
require 'support/controllers_helper'

RSpec.describe V1::SignupController do
  let!(:some_user) {FactoryBot.build(:user)}
  describe 'POST #signup' do
    describe 'with correct values' do
      let!(:signup) {post :signup, params: {
          email: some_user.email,
          name: some_user.name,
          password: some_user.password,
          password_confirmation: some_user.password
      }
      }

      it 'returns http created' do
        expect(response).to have_http_status(:created)
      end

      it 'returns id and name of the user' do
        expect(JSON.parse(response.body).keys).to match(%w[id name email])
      end
    end

    describe 'with incorrect values' do
      describe 'when missing name' do
        let!(:signup) {post :signup, params: {
            email: some_user.email,
            password: some_user.password,
            password_confirmation: some_user.password
        }
        }

        it 'returns http Unprocessable Entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message containing name key' do
          expect(JSON.parse(response.body).keys).to match(%w[name])
        end
      end

      describe 'when missing email' do
        let!(:signup) {post :signup, params: {
            name: some_user.name,
            password: some_user.password,
            password_confirmation: some_user.password
        }
        }

        it 'returns http Unprocessable Entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message containing email key' do
          expect(JSON.parse(response.body).keys).to match(%w[email])
        end
      end

      describe 'when missing password' do
        let!(:signup) {post :signup, params: {
            email: some_user.email,
            name: some_user.name,
            password_confirmation: some_user.password
        }
        }

        it 'returns http Unprocessable Entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error messages containing password and password_digest keys' do
          expect(JSON.parse(response.body).keys).to match(%w[password password_digest])
        end
      end

      describe 'and mismatched password and password confirmation values are given' do
        let!(:signup) {post :signup, params: {
            email: some_user.email,
            name: some_user.name,
            password: some_user.password,
            password_confirmation: "#{rand(100)}"
        }
        }

        it 'returns http Unprocessable Entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message containing password confirmation key' do
          expect(JSON.parse(response.body).keys).to match(%w[password_confirmation])
        end
      end

    end

  end
end