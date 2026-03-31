require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品' do
    context '出品できるとき' do
      it '全ての項目が存在すれば登録できる' do
        expect(@item).to be_valid
      end
    end

    context '出品できないとき' do
      it '画像が空では登録できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("画像を入力してください")
      end

      it '価格が300円未満では登録できない' do
        @item.item_price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include("販売価格は300以上の値にしてください")
      end

      it 'カテゴリーで「---」(id:1)を選択すると登録できない' do
        @item.item_category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("カテゴリーを選択してください")
      end
      
      it '価格に半角数字以外が含まれている場合は登録できない' do
        @item.item_price = "１０００" # 全角
        @item.valid?
        expect(@item.errors.full_messages).to include("販売価格は半角数値で入力してください")
      end
    end
  end
end
