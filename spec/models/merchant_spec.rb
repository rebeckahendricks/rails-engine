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
    describe '.good_id?' do
      it 'can determine if a merchant id is good' do
        merchant_id = create(:merchant).id

        expect(Merchant.good_id?(merchant_id)).to be(true)
        expect(Merchant.good_id?(5)).to be(false)
      end
    end

    describe '.search_by_name(search_params)' do
      it 'can search for a merchant by name' do
        create(:merchant, name: 'Walmart')
        merchant1 = create(:merchant, name: 'Dogmart')
        create(:merchant, name: 'Bobs Baskets')

        search_params = 'Mart'

        expect(Merchant.search_by_name(search_params)).to eq(merchant1)
      end
    end
  end
end
