require 'rails_helper'

describe 'Items::Search API' do
  describe 'happy path' do
    it 'can find the first item (in alphabetical order) based on name search criteria' do
      merchant = create(:merchant)
      create(:item, merchant_id: merchant.id, name: 'Titanium Ring', description: 'Pretty')
      create(:item, merchant_id: merchant.id, name: 'Chime', description: 'This silver chime will bring you cheer!')
      item = create(:item, merchant_id: merchant.id, name: 'gold earring', description: 'also pretty')

      search = 'ring'

      get "/api/v1/items/find?name=#{search}"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      search_results = JSON.parse(response.body, symbolize_names: true)

      expect(search_results[:data][:id].to_i).to eq(item.id)
      expect(search_results[:data][:attributes][:name]).to eq(item.name)
      expect(search_results[:data][:attributes][:description]).to eq(item.description)
    end

    it 'can find all items (in alphabetical order) based on name search criteria' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, name: 'Titanium Ring', description: 'Pretty')
      create(:item, merchant_id: merchant.id, name: 'Chime', description: 'This silver chime will bring you cheer!')
      item2 = create(:item, merchant_id: merchant.id, name: 'gold earring', description: 'also pretty')

      search = 'ring'

      get "/api/v1/items/find_all?name=#{search}"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      search_results = JSON.parse(response.body, symbolize_names: true)

      expect(search_results[:data].count).to eq(2)
      expect(search_results[:data]).to be_an(Array)

      expect(search_results[:data][0][:id].to_i).to eq(item2.id)
      expect(search_results[:data][1][:id].to_i).to eq(item1.id)

      expect(search_results[:data][0][:attributes][:name]).to eq(item2.name)
      expect(search_results[:data][1][:attributes][:name]).to eq(item1.name)

      expect(search_results[:data][0][:attributes][:description]).to eq(item2.description)
      expect(search_results[:data][1][:attributes][:description]).to eq(item1.description)
    end

    it 'can find all items (in alphabetical order) based on minimum price criteria' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
      item2 = create(:item, merchant_id: merchant.id, name: 'zebra', unit_price: 99.99)
      item3 = create(:item, merchant_id: merchant.id, name: 'Apple', unit_price: 35.99)
      item4 = create(:item, merchant_id: merchant.id, name: 'Elephant', unit_price: 599.99)

      min_price = 50

      get "/api/v1/items/find_all?min_price=#{min_price}"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      search_results = JSON.parse(response.body, symbolize_names: true)

      expect(search_results[:data].count).to eq(2)
      expect(search_results[:data]).to be_an(Array)

      expect(search_results[:data][0][:id].to_i).to eq(item4.id)
      expect(search_results[:data][1][:id].to_i).to eq(item2.id)

      expect(search_results[:data][0][:attributes][:name]).to eq(item4.name)
      expect(search_results[:data][1][:attributes][:name]).to eq(item2.name)
    end

    it 'can find all items (in alphabetical order) based on maximum price criteria' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
      item2 = create(:item, merchant_id: merchant.id, name: 'zebra', unit_price: 99.99)
      item3 = create(:item, merchant_id: merchant.id, name: 'Apple', unit_price: 35.99)
      item4 = create(:item, merchant_id: merchant.id, name: 'Elephant', unit_price: 599.99)

      max_price = 150.01

      get "/api/v1/items/find_all?max_price=#{max_price}"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      search_results = JSON.parse(response.body, symbolize_names: true)

      expect(search_results[:data].count).to eq(3)
      expect(search_results[:data]).to be_an(Array)

      expect(search_results[:data][0][:id].to_i).to eq(item3.id)
      expect(search_results[:data][1][:id].to_i).to eq(item1.id)
      expect(search_results[:data][2][:id].to_i).to eq(item2.id)

      expect(search_results[:data][0][:attributes][:name]).to eq(item3.name)
      expect(search_results[:data][1][:attributes][:name]).to eq(item1.name)
      expect(search_results[:data][2][:attributes][:name]).to eq(item2.name)
    end

    it 'can find all items (in alphabetical order) based on minimum and maximum price criteria' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
      item2 = create(:item, merchant_id: merchant.id, name: 'zebra', unit_price: 99.99)
      item3 = create(:item, merchant_id: merchant.id, name: 'Apple', unit_price: 35.99)
      item4 = create(:item, merchant_id: merchant.id, name: 'Elephant', unit_price: 599.99)

      min_price = 30.99
      max_price = 150

      get "/api/v1/items/find_all?min_price=#{min_price}&max_price=#{max_price}"

      expect(response).to be_successful
      expect(response).to have_http_status(200)
      search_results = JSON.parse(response.body, symbolize_names: true)

      expect(search_results[:data].count).to eq(2)
      expect(search_results[:data]).to be_an(Array)

      expect(search_results[:data][0][:id].to_i).to eq(item3.id)
      expect(search_results[:data][1][:id].to_i).to eq(item2.id)

      expect(search_results[:data][0][:attributes][:name]).to eq(item3.name)
      expect(search_results[:data][1][:attributes][:name]).to eq(item2.name)
    end
  end

  describe 'sad path' do
    it 'returns an array if there are no items found based on search criteria' do
      merchant = create(:merchant)
      create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
      create(:item, merchant_id: merchant.id, name: 'Zebra', unit_price: 99.99)

      min_price = 50
      max_price = 80

      get "/api/v1/items/find_all?min_price=#{min_price}&max_price=#{max_price}"

      expect(response).to be_successful
      search_results = JSON.parse(response.body, symbolize_names: true)

      expect(search_results[:data].count).to eq(0)
      expect(search_results[:data]).to be_an(Array)
    end

    it 'returns a status code 200, even if there are no items found' do
      merchant = create(:merchant)
      create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
      create(:item, merchant_id: merchant.id, name: 'Zebra', unit_price: 99.99)

      min_price = 50.49
      max_price = 80

      get "/api/v1/items/find_all?min_price=#{min_price}&max_price=#{max_price}"

      expect(response).to have_http_status(200)
    end

    it 'cannot search for both name and minimum price' do
      merchant = create(:merchant)
      create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
      create(:item, merchant_id: merchant.id, name: 'Zebra', unit_price: 99.99)

      search_name = 'Zebra'
      min_price = 50

      get "/api/v1/items/find_all?name=#{search_name}&min_price=#{min_price}"
      expect(response).to have_http_status(400)
    end

    it 'cannot search for both name and maximum price' do
      merchant = create(:merchant)
      create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
      create(:item, merchant_id: merchant.id, name: 'Zebra', unit_price: 99.99)

      search_name = 'Zebra'
      max_price = 150.99

      get "/api/v1/items/find_all?name=#{search_name}&max_price=#{max_price}"
      expect(response).to have_http_status(400)
    end

    it 'cannot search for both name and minumum and maximum price' do
      merchant = create(:merchant)
      create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
      create(:item, merchant_id: merchant.id, name: 'Zebra', unit_price: 99.99)

      search_name = 'Zebra'
      min_price = 50
      max_price = 150.99

      get "/api/v1/items/find_all?name=#{search_name}&min_price=#{min_price}&max_price=#{max_price}"
      expect(response).to have_http_status(400)
    end

    it 'cannot search for a negative number' do
      merchant = create(:merchant)
      create(:item, merchant_id: merchant.id, name: 'Ball', unit_price: 1.99)
      create(:item, merchant_id: merchant.id, name: 'Zebra', unit_price: 99.99)

      min_price = -150
      max_price = -25

      get "/api/v1/items/find_all?max_price=#{max_price}"
      expect(response).to have_http_status(400)

      get "/api/v1/items/find_all?max_price=#{min_price}"
      expect(response).to have_http_status(400)

      get "/api/v1/items/find_all?min_price=#{min_price}&max_price=#{max_price}"
      expect(response).to have_http_status(400)
    end
  end
end
