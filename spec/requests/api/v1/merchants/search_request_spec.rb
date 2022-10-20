require 'rails_helper'

describe 'Merchants::Search API' do
  describe 'happy path' do
    it 'can find one merchant from a name search' do
      create(:merchant, name: 'Walmart')
      merchant1 = create(:merchant, name: 'dogmart')
      create(:merchant, name: 'Bobs Baskets')

      search = 'Mart'

      get "/api/v1/merchants/find?name=#{search}"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
      expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
    end
  end

  describe 'sad path' do
    it 'returns an empty object with "data" if no results match' do
      create(:merchant, name: 'Walmart')
      create(:merchant, name: 'dogmart')
      create(:merchant, name: 'Bobs Baskets')

      search = 'abcdefghijklmnop'

      get "/api/v1/merchants/find?name=#{search}"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data].count).to eq(0)
    end
  end

  describe 'happy path' do
    it 'can return all merchants that match a name search' do
      merchant1 = create(:merchant, name: 'Walmart')
      merchant2 = create(:merchant, name: 'dogmart')
      create(:merchant, name: 'Bobs Baskets')

      search = 'Mart'

      get "/api/v1/merchants/find_all?name=#{search}"

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(merchant[:data].count).to eq(2)

      expect(merchant[:data][0][:attributes][:name]).to eq(merchant2.name)
      expect(merchant[:data][1][:attributes][:name]).to eq(merchant1.name)
    end
  end
end
