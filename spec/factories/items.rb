FactoryBot.define do
  factory :item do
    item_name                  { '商品名' }
    item_info                  { '商品の説明' }
    item_category_id           { 2 } # 1以外
    item_sales_status_id       { 2 }
    item_shipping_fee_status_id { 2 }
    item_prefecture_id { 2 }
    item_scheduled_delivery_id { 2 }
    item_price { 1000 }
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    end
  end
end
