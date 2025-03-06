FactoryBot.define do
    factory :coupon do
        name { Faker::Lorem.word }
        code { Faker::Lorem.unique.word }
        dollar_off { Faker::Number.number(digits: 2) }
        merchant
    end
end