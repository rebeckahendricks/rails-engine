require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    merchant = create(:merchant)

    3.times do
      create(:item, merchant_id: merchant.id)
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

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it 'can get one item by its id' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

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

  describe 'happy path' do
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
  end

  describe 'sad path' do
    it 'returns an error if any attributes are missing when creating an item' do
      merchant = create(:merchant)

      item_params = {
        merchant_id: merchant.id,
        name: "",
        description: Faker::Lorem.sentence,
        unit_price: Faker::Number.decimal(l_digits: 3, r_digits: 2)
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(400)
      expect(Item.count).to eq(0)
    end

    it 'returns an error if any attributes are incorrect when creating an item' do
      merchant = create(:merchant)

      item_params = {
        merchant_id: merchant.id,
        name: Faker::Lorem.word,
        description: Faker::Lorem.sentence,
        unit_price: 'Hello'
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(400)
      expect(Item.count).to eq(0)
    end
  end

  describe 'happy path' do
    it 'can update an existing item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

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

  describe 'sad path' do
    it 'only updates an existing item if attributes are valid' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      previous_unit_price = item.unit_price
      item_params = {
        unit_price: 'Hello'
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({ item: item_params })

      item = Item.find_by(id: item.id)

      expect(item.unit_price).to eq(previous_unit_price)
      expect(item.unit_price).to_not eq('Hello')
    end

    it 'only updates an existing item if the merchant id exists' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      previous_unit_price = item.unit_price
      item_params = {
        merchant_id: 'Hello'
      }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({ item: item_params })

      item = Item.find_by(id: item.id)

      expect(response).to have_http_status(400)
      expect(item.unit_price).to eq(previous_unit_price)
      expect(item.unit_price).to_not eq('Hello')
    end
  end

  describe 'destroy' do
    it 'can destroy an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'destroys any invoice if this was the only item on an invoice' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      customer = create(:customer)
      invoice = create(:invoice, customer_id: customer.id, merchant_id: merchant.id)

      create(:invoice_item, item_id: item1.id, invoice_id: invoice.id)
      create(:invoice_item, item_id: item2.id, invoice_id: invoice.id)

      expect(Invoice.count).to eq(1)
      expect(Invoice.first.items.count).to eq(2)
      expect(Item.count).to eq(2)
      expect(InvoiceItem.count).to eq(2)

      delete "/api/v1/items/#{item1.id}"

      expect(Invoice.count).to eq(1)
      expect(Item.count).to eq(1)
      expect(InvoiceItem.count).to eq(1)

      delete "/api/v1/items/#{item2.id}"

      expect(Invoice.count).to eq(0)
      expect(Item.count).to eq(0)
      expect(InvoiceItem.count).to eq(0)
    end
  end
end
