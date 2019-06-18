require 'rails_helper'
require 'spec_helper'

RSpec.describe Recipe, type: :model do
  let(:recipe) { build(:recipe) }

  describe 'ActiveModel validations' do
    it { is_expected.to validate_presence_of(:ingredients) }
    it { is_expected.to validate_presence_of(:directions) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:servings) }
    it { is_expected.to validate_presence_of(:time_to_prepare) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_numericality_of(:time_to_prepare) }
    it { is_expected.to validate_numericality_of(:servings) }
  end

  describe 'ActiveRecord associations' do
    # Associations
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:directions) }
    it { is_expected.to have_many(:ingredients) }
    it { is_expected.to accept_nested_attributes_for(:directions) }
    it { is_expected.to accept_nested_attributes_for(:ingredients) }
  end
end