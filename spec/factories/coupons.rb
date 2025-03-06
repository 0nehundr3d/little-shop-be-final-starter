FactoryBot.define do
    factory :coupon do
        name { Faker::Lorem.word }
        code { Faker::Lorem.unique.word }
        dollar_off { Faker::Number.number(digits: 2) }
        percent_off { nil }
        merchant
        invoice
    end
end