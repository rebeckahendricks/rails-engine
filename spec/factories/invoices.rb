FactoryBot.define do
  factory :invoice do
    customer_id { Faker::Number.within(range: 1..10) }
    status { ['In Progress', 'Completed', 'Cancelled'].sample }
  end
end