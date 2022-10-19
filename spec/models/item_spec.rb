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
    describe '.search_by_name(search_params)' do
      it 'can return (alphabetically) all items with search params in its name and description' do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id, name: 'Titanium Ring', description: 'Pretty')
        item2 = create(:item, merchant_id: merchant.id, name: 'Chime', description: 'This silver chime will bring you cheer!')
        create(:item, merchant_id: merchant.id, name: 'Buckle', description: 'Belt')

        expect(Item.search_by_name('ring')).to eq([item2, item1])
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

        InvoiceItem.create!(
          item_id: item1.id,
          invoice_id: invoice1.id,
          quantity: Faker::Number.within(range: 1..100),
          unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2) 
        )

        InvoiceItem.create!(
          item_id: item1.id,
          invoice_id: invoice2.id,
          quantity: Faker::Number.within(range: 1..100),
          unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2) 
        )

        InvoiceItem.create!(
          item_id: item2.id,
          invoice_id: invoice2.id,
          quantity: Faker::Number.within(range: 1..100),
          unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2) 
        )

        expect(item1.invoice_items.count).to eq(2)
        expect(item2.invoice_items.count).to eq(1)

        item1.destroy_invoice_items

        expect(item1.invoice_items.count).to eq(0)
        expect(item2.invoice_items.count).to eq(1)
      end
    end
  end
end
