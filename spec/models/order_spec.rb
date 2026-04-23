require 'rails_helper'

RSpec.describe "Orders", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item) # 別のユーザーが出品した商品
  end

  describe "GET /items/:item_id/orders" do
    it "ログインしていない場合、ログイン画面に遷移すること" do
      get item_orders_path(@item)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "自身が出品した商品の購入ページに遷移しようとすると、トップページに遷移すること" do
      sign_in @item.user # 出品者としてログイン
      get item_orders_path(@item)
      expect(response).to redirect_to(root_path)
    end

    it "売却済みの商品の購入ページに遷移しようとすると、トップページに遷移すること" do
      sign_in @user
      # 売却済みにする（Orderを作成）
      FactoryBot.create(:order, item_id: @item.id, user_id: @user.id)
      get item_orders_path(@item)
      expect(response).to redirect_to(root_path)
    end
  end
end

