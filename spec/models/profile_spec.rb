require 'rails_helper'
require 'spec_helper'

RSpec.describe Profile, type: :model do
  let(:profile) {build(:profile)}

  describe 'ActiveModel validations' do
    it {is_expected.to validate_presence_of(:title)}
    it {is_expected.to validate_presence_of(:description)}
  end

  describe 'ActiveRecord associations' do
    # Associations
    it {expect(profile).to have_many(:users)}
  end
end