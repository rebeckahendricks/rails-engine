require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe '.class methods' do
    describe '.find_by_name(search_params)' do
      it 'can return the first item (alphabetically) with search params in its name' do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id, name: 'Titanium Ring', description: 'Pretty')
        create(:item, merchant_id: merchant.id, name: 'Chime', description: 'This silver chime will bring you cheer!')
        item3 = create(:item, merchant_id: merchant.id, name: 'bronze ring', description: 'also pretty')

        expect(Item.find_by_name('ring')).to eq(item3)
      end
    end

    describe '.find_all_by_name(search_params)' do
      it 'can return (alphabetically) all items with search params in its name' do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id, name: 'Titanium Ring', description: 'Pretty')
        create(:item, merchant_id: merchant.id, name: 'Chime', description: 'This silver chime will bring you cheer!')
        item3 = create(:item, merchant_id: merchant.id, name: 'bronze ring', description: 'also pretty')

        expect(Item.find_all_by_name('ring')).to eq([item3, item1])
      end
    end

    describe 'find_by_price(search_params)' do
      it 'can return (alphabetically) the first item within a minimum and/or maximum unit_price range' do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
        item2 = create(:item, merchant_id: merchant.id, name: 'zebra', unit_price: 99.99)
        item3 = create(:item, merchant_id: merchant.id, name: 'Apple', unit_price: 35.99)
        item4 = create(:item, merchant_id: merchant.id, name: 'Elephant', unit_price: 599.99)

        min_price = 50.49
        max_price = 150

        expect(Item.find_by_price(min_price: min_price, max_price: nil)).to eq(item4)
        expect(Item.find_by_price(min_price: nil, max_price: max_price)).to eq(item3)
        expect(Item.find_by_price(min_price: min_price, max_price: max_price)).to eq(item2)
      end
    end

    describe 'find_all_by_price(search_params)' do
      it 'can return (alphabetically) all items within a minimum and/or maximum unit_price range' do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
        item2 = create(:item, merchant_id: merchant.id, name: 'zebra', unit_price: 99.99)
        item3 = create(:item, merchant_id: merchant.id, name: 'Apple', unit_price: 35.99)
        item4 = create(:item, merchant_id: merchant.id, name: 'Elephant', unit_price: 599.99)

        min_price = 50.49
        max_price = 150

        expect(Item.find_all_by_price(min_price: min_price, max_price: nil)).to eq([item4, item2])
        expect(Item.find_all_by_price(min_price: nil, max_price: max_price)).to eq([item3, item1, item2])
        expect(Item.find_all_by_price(min_price: min_price, max_price: max_price)).to eq([item2])
      end
    end
  end

  describe '#instance methods' do
    describe '#destroy_invoice_items' do
      it 'can destroy an items invoice_items' do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        customer1 = create(:customer)
        customer2 = create(:customer)
        invoice1 = create(:invoice, customer_id: customer1.id, merchant_id: merchant.id)
        invoice2 = create(:invoice, customer_id: customer2.id, merchant_id: merchant.id)

        create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id)
        create(:invoice_item, item_id: item1.id, invoice_id: invoice2.id)
        create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id)

        expect(item1.invoice_items.count).to eq(2)
        expect(item2.invoice_items.count).to eq(1)

        item1.destroy_invoice_items

        expect(item1.invoice_items.count).to eq(0)
        expect(item2.invoice_items.count).to eq(1)
      end
    end
  end
end
