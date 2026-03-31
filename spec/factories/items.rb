FactoryBot.define do
  factory :item do
    item_name { "MyString" }
    item_info { "MyText" }
    item_category_id { 1 }
    item_sales_status_id { 1 }
    item_shipping_fee_status_id { 1 }
    item_prefecture_id { 1 }
    item_scheduled_delivery_id { 1 }
    item_price { 1 }
    user { nil }
  end
end
