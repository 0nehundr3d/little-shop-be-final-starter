FactoryBot.define do
    factory :coupon do
        name { Faker::Lorem.word }
        code { Faker::Lorem.unique.word }
        percent { true }
        discount { Faker::Number.number(digits: 2) }
        merchant
        invoice
    end
end