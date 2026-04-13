class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]

  def index
    @items = Item.all.order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id]) # 編集する商品を特定
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params) # ストロングパラメータを使用して更新
      redirect_to item_path(@item), notice: '商品情報を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def item_params
    params.require(:item).permit(
      :image,
      :item_name, :item_info, :item_category_id, :item_sales_status_id,
      :item_shipping_fee_status_id, :item_prefecture_id,
      :item_scheduled_delivery_id, :item_price
    ).merge(user_id: current_user.id)
  end

  def contributor_confirmation
    @item = Item.find(params[:id])
    # ログインしているユーザーと出品者が一致しない場合は、トップページへ戻す
    redirect_to root_path unless current_user.id == @item.user_id
  end
end
