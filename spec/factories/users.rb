FactoryBot.define do
  factory :user do
    nickname              { 'test' }
    email                 { 'test@example.com' }
    password              { '1a2b3c' } # 英数字混合
    password_confirmation { password }
    last_name             { '山田' }
    first_name            { '海太郎' }
    last_name_kana        { 'ヤマダ' }
    first_name_kana       { 'ウミタロウ' }
    birth_date            { '1950-02-02' }
  end
end
