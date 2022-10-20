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
      it 'can determine if a merchant id exists or is not nil' do
        merchant_id = create(:merchant).id

        expect(Merchant.good_id?(merchant_id)).to be(true)
        expect(Merchant.good_id?(5)).to be(false)
      end
    end

    describe '.find_by_name(search_params)' do
      it 'can search for a merchant by name' do
        create(:merchant, name: 'Walmart')
        merchant = create(:merchant, name: 'dogmart')
        create(:merchant, name: 'Bobs Baskets')

        search_params = 'Mart'

        expect(Merchant.find_by_name(search_params)).to eq(merchant)
      end
    end

    describe '.find_all_by_name(search_params)' do
      it 'can search for a merchant by name' do
        merchant1 = create(:merchant, name: 'Walmart')
        merchant2 = create(:merchant, name: 'dogmart')
        create(:merchant, name: 'Bobs Baskets')

        search_params = 'Mart'

        expect(Merchant.find_all_by_name(search_params)).to eq([merchant2, merchant1])
      end
    end
  end
end
