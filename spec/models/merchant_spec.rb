require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
    it 'can determine if a merchant id is good' do
      merchant_id = create(:merchant).id

      expect(Merchant.good_id?(merchant_id)).to be(true)
      expect(Merchant.good_id?(5)).to be(false)
    end
  end
end
