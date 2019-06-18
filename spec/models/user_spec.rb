require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  let(:user) {build(:user)}

  describe 'ActiveModel validations' do
    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_presence_of(:email)}
    it {is_expected.to validate_uniqueness_of(:email)}
    it {is_expected.to validate_presence_of(:password_digest)}

    describe 'with invalid email' do
      before {user.email = 'user@example,com'}
      it {should_not be_valid}
    end
  end

  describe 'ActiveRecord associations' do
    # Associations
    it {expect(user).to have_many(:recipes)}
    it {expect(user).to belong_to(:profile)}
    it {is_expected.to accept_nested_attributes_for(:recipes)}
  end

  describe 'public instance methods' do
    context 'executes methods correctly' do
      context 'when admin' do
        let(:user_with_admin_profile) {create(:user, profile: Profile.first)}
        context '#admin?' do
          it {expect(user_with_admin_profile.admin?).to match(true)}
        end

        context '#cook?' do
          it {expect(user_with_admin_profile.cook?).to match(false)}
        end
      end

      context 'when cook' do
        let(:user_with_cook_profile) {create(:user, profile: Profile.second)}
        context '#admin?' do
          it {expect(user_with_cook_profile.admin?).to match(false)}
        end

        context '#cook?' do
          it {expect(user_with_cook_profile.cook?).to match(true)}
        end
      end
    end
  end

  describe 'public class methods' do
    let(:new_user) {build(:user)}
    let(:params) {{email: new_user.email, name: new_user.name, password: new_user.password, password_confirmation: new_user.password}}
    let(:cook) {User.new_cook(params)}

    context 'executes methods correctly' do
      context 'self.new_cook' do
        it 'creates a new user with a cook profile' do
          expect(cook.profile).to eq(Profile.second)
        end
      end
    end
  end
end
