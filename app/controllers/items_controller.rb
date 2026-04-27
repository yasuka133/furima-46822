class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]
  before_action :check_sold_out, only: [:edit, :update]

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
  end

  def edit
  end

  def update
    if @item.update(item_params) # ストロングパラメータを使用して更新
      redirect_to item_path(@item), notice: '商品情報を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.id == @item.user_id
      if @item.destroy
        redirect_to root_path, notice: '商品を削除しました'
      else
        redirect_to item_path(@item), alert: '取引中のため削除できません'
      end
    else
      # 本人でない場合はそのままトップへ
      redirect_to root_path
    end
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

  def set_item
    @item = Item.find(params[:id])
  end

  def contributor_confirmation
    puts "current_user: #{current_user.id}, item_user: #{@item.user_id}"
    redirect_to item_path(@item) unless current_user.id == @item.user_id
  end

  def check_sold_out
    return unless @item.order.present?

    redirect_to item_path(@item)
  end
end
