FactoryBot.define do
  factory :invoice do
    customer_id { Faker::Number.within(range: 1..10) }
    status { Faker::Number.within(range: 0..2) }
  end
end