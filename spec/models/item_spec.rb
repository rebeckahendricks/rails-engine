require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    # it { should validate_presence_of(:merchant_id) }
  end
end
