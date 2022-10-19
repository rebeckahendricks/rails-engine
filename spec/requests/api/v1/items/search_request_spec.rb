require 'rails_helper'

describe 'Items::Search API' do
  describe 'happy path' do
    it 'can find all items (in alphabetical order) based on name search criteria' do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, name: 'Titanium Ring', description: 'Pretty')
      item2 = create(:item, merchant_id: merchant.id, name: 'Chime', description: 'This silver chime will bring you cheer!')
      create(:item, merchant_id: merchant.id, name: 'Buckle', description: 'Belt')

      search = 'ring'

      get "/api/v1/items/find_all?name=#{search}"

      expect(response).to be_successful
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

    it 'can find all items (in alphabetical order) based on min/max price criteria' do
      
    end
  end

  describe 'sad path' do
    it 'returns an array if there are no items found based on search criteria' do
      
    end

    it 'returns a status code 200, even if there are no items found' do
      
    end
  end
end