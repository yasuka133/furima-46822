FactoryBot.define do
  factory :user do
    nickname              { Faker::Name.initials(number: 2) }
    sequence(:email)      { |n| "test#{n}@example.com" }
    # email                 { Faker::Internet.unique.email }
    password              { '1a2b3c4D' }
    password_confirmation { password }
    last_name             { '山田' }
    first_name            { '海太郎' }
    last_name_kana        { 'ヤマダ' }
    first_name_kana       { 'ウミタロウ' }
    birth_date            { Faker::Date.backward(days: 30_000) }
  end
end
