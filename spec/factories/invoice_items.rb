FactoryBot.define do
  factory :invoice_item do
    item_id { Faker::Number.within(range: 1..10) }
    invoice_id { Faker::Number.within(range: 1..10) }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    quantity { Faker::Number.within(range: 1..100) }
  end
end
