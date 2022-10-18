require 'rails_helper'

describe 'MerchantItems API' do
  it 'sends a list of items associated with a merchant' do
    create_list(:merchant, 2)
    merchant1 = Merchant.first
    merchant2 = Merchant.last

    3.times do
      Item.create!(
        merchant_id: merchant1.id,
        name: Faker::Lorem.word,
        description: Faker::Lorem.sentence,
        unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2)
      )
    end

    Item.create!(
      merchant_id: merchant2.id,
      name: Faker::Lorem.word,
      description: Faker::Lorem.sentence,
      unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2)
    )

    get "/api/v1/merchants/#{merchant1.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes][:merchant_id]).to eq(merchant1.id)
    end
  end
end

