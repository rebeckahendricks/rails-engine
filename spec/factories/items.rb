FactoryBot.define do
  factory :item do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    merchant_id { Faker::Number.within(range: 1..10) }
  end
end
