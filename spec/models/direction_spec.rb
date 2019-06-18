require 'rails_helper'
require 'spec_helper'

RSpec.describe Direction, type: :model do
  let(:direction) {build(:direction)}

  it 'has a valid factory' do
    expect(build(:direction)).to be_valid
  end

  describe 'ActiveModel validations' do
    it {is_expected.to validate_presence_of(:step)}
    it {is_expected.to validate_presence_of(:description)}
    it { is_expected.to validate_numericality_of(:step) }
  end

  describe 'ActiveRecord associations' do
    # Associations
    it {expect(direction).to belong_to(:recipe)}
  end
end