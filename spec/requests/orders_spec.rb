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

    context "ログインしている場合" do
      before do
        sign_in @user
      end

      it "自身が出品した商品の購入ページに遷移しようとすると、トップページに遷移すること" do
        sign_in @item.user # 出品者としてログインし直す
        get item_orders_path(@item)
        expect(response).to redirect_to(root_path)
      end

      it "売却済みの商品の購入ページに遷移しようとすると、トップページに遷移すること" do
        # 別のユーザーが購入済みの状態を作る
        another_user = FactoryBot.create(:user)
        FactoryBot.create(:order, item_id: @item.id, user_id: another_user.id)
        
        get item_orders_path(@item)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
