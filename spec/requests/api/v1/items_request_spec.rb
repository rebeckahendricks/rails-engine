require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    merchant = create(:merchant)

    3.times do
      Item.create!(
        merchant_id: merchant.id,
        name: Faker::Lorem.word,
        description: Faker::Lorem.sentence,
        unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2)
      )
    end

    get '/api/v1/items'

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
    end
  end

  it 'can get one item by its id' do
    merchant = create(:merchant)

    item = Item.create!(
      merchant_id: merchant.id,
      name: Faker::Lorem.word,
      description: Faker::Lorem.sentence,
      unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2)
    )

    get "/api/v1/items/#{item.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
  end

  it 'can create a new item' do
    merchant = create(:merchant)

    item_params = {
      merchant_id: merchant.id,
      name: Faker::Lorem.word,
      description: Faker::Lorem.sentence,
      unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2)
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
  end

  it 'can update an existing item' do
    merchant = create(:merchant)

    item = Item.create!(
      merchant_id: merchant.id,
      name: Faker::Lorem.word,
      description: Faker::Lorem.sentence,
      unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2)
    )

    previous_name = item.name
    item_params = {
      name: 'Fork'
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({ item: item_params })

    item = Item.find_by(id: item.id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('Fork')
  end
end
