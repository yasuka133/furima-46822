class OrderAddress
  include ActiveModel::Model
  # 保存したいカラムをすべて定義
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city, :house_number, :building, :phone_number, :token

  # ここにバリデーション（入力チェック）を記述
  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :postal_code, format: {with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)"}
    validates :prefecture_id, numericality: {other_than: 1, message: "can't be blank"}
    validates :city
    validates :house_number
    validates :phone_number, format: {with: /\A\d{10,11}\z/, message: "is invalid"}
    validates :token # あとでJavaScriptから送られてくる値
  end

  def save
    # 購入記録を保存
    order = Order.create(user_id: user_id, item_id: item_id)
    # 住所を保存
    Address.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city, house_number: house_number, building: building, phone_number: phone_number, order_id: order.id)
  end
end
