require 'rails_helper'

describe 'ItemsMerchant API' do
  it 'can get one merchant by its items' do
    create_list(:merchant, 2)
    merchant1 = Merchant.first
    merchant2 = Merchant.last

    item1 = create(:item, merchant_id: merchant1.id)
    create(:item, merchant_id: merchant2.id)

    get "/api/v1/items/#{item1.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data]).to be_a(Hash)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:id]).to eq(merchant1.id.to_s)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
  end
end