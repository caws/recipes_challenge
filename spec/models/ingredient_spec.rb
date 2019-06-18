require 'rails_helper'
require 'spec_helper'

RSpec.describe Ingredient, type: :model do
  let(:ingredient) {build(:ingredient)}

  it 'has a valid factory' do
    expect(build(:ingredient)).to be_valid
  end

  describe 'ActiveModel validations' do
    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_presence_of(:measurement)}
  end

  describe 'ActiveRecord associations' do
    # Associations
    it {expect(ingredient).to belong_to(:recipe)}
  end
end