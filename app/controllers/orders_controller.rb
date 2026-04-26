class OrdersController < ApplicationController
  before_action :authenticate_user! # ログインしていないユーザーをログイン画面へ飛ばす
  before_action :set_item # どの商品に関する購入か特定する
  before_action :prevent_self_purchase # 自身が出品した商品の購入を制限する

  def index
    # 決済用フォームに渡す空のオブジェクトを作成
    @order_address = OrderAddress.new
  end

  def create
    # フォームから送られてきたデータを受け取る
    @order_address = OrderAddress.new(order_params)

    if @order_address.valid?
      Payjp.api_key = 'sk_test_e35a50da2b7e3aa9c4c52674' # テスト用秘密鍵
      Payjp::Charge.create(
        amount: @item.item_price,    # 商品の値段
        card: order_params[:token],  # JavaScriptから届いたトークン
        currency: 'jpy'              # 日本円
      )

      @order_address.save # Formオブジェクトのsaveメソッドを実行
      redirect_to root_path, notice: '購入が完了しました'
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def order_params
    # フォームから送られてくる情報を許可（user_idとitem_idも合体させる）
    params.require(:order_address).permit(
      :postal_code, :prefecture_id, :city, :house_number, :building, :phone_number
    ).merge(
      user_id: current_user.id,
      item_id: params[:item_id],
      token: params[:token]
    )
  end

  def prevent_self_purchase
    # 出品者本人、またはすでに売却済みの場合はトップページへ戻す
    return unless current_user.id == @item.user_id || @item.order.present?

    redirect_to root_path
  end
end
