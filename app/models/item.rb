class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :item_category,           class_name: 'Category'
  belongs_to :item_sales_status,       class_name: 'ItemSalesStatus'
  belongs_to :item_shipping_fee_status, class_name: 'ShippingFeeStatus'
  belongs_to :item_prefecture,         class_name: 'Prefecture'
  belongs_to :item_scheduled_delivery, class_name: 'ScheduledDelivery'

  # アソシエーション
  belongs_to :user
  has_one_attached :image

  # 全ての項目が空では保存できないようにするバリデーション
  with_options presence: true do
    validates :image
    validates :item_name
    validates :item_info
    validates :item_category_id
    validates :item_sales_status_id
    validates :item_shipping_fee_status_id
    validates :item_prefecture_id
    validates :item_scheduled_delivery_id

    # 価格のバリデーション（300〜9,999,999の範囲指定）
    validates :item_price, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 300,
      less_than_or_equal_to: 9_999_999
    }
  end

  # ジャンル選択が「---」（id: 1）の時は保存できないようにするバリデーション
  with_options numericality: { other_than: 1 } do
    validates :item_category_id
    validates :item_sales_status_id
    validates :item_shipping_fee_status_id
    validates :item_prefecture_id
    validates :item_scheduled_delivery_id
  end

  # 画像が空であることを許さない設定
  validates :image, presence: true, unless: :was_attached?

  def was_attached?
    image.attached?
  end
end
