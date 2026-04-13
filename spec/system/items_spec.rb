require 'rails_helper'

RSpec.describe '商品情報編集', type: :system do
  before do
    @item = FactoryBot.create(:item) # 出品者 A の商品
    @user = FactoryBot.create(:user) # 別ユーザー B
  end

  context '商品編集画面へ遷移できるとき' do
    it 'ログイン状態の出品者は、自身が出品した販売中商品の編集ページに遷移できる' do
      # 出品者としてログイン
      sign_in(@item.user)
      # 詳細ページへ
      visit item_path(@item)
      # 編集ボタンがあることを確認してクリック
      expect(page).to have_link('商品の編集', href: edit_item_path(@item))
      visit edit_item_path(@item)
      # 編集ページに遷移したことを確認
      expect(current_path).to eq(edit_item_path(@item))
    end
  end

  context '商品編集画面へ遷移できないとき' do
    # it 'ログイン状態でも、自身が出品した売却済み商品の編集ページへ遷移しようとすると、トップページに遷移する' do
    # 売却済みの状態を作る（Orderを作成）
    # @order = FactoryBot.create(:order, item: @item)
    # sign_in(@item.user)
    # 直接編集ページへアクセス
    # visit edit_item_path(@item)
    # トップページに押し戻されることを確認
    # expect(current_path).to eq(root_path)
    # end

    it 'ログイン状態でも、自身が出品していない商品の編集ページへ遷移しようとすると、トップページに遷移する' do
      # 別ユーザーでログイン
      sign_in(@user)
      # 他人の商品の編集ページへアクセス
      visit edit_item_path(@item)
      # トップページに押し戻されることを確認
      expect(current_path).to eq(root_path)
    end

    it '内容に不備がある（空欄など）場合は編集に失敗し、編集画面に戻る' do
      sign_in(@item.user)
      visit edit_item_path(@item)
      # 商品名を空にする
      fill_in 'item-name', with: ''
      click_on '変更する'
      # 保存に失敗し、編集画面（/items/ID）に戻っていることを確認
      expect(current_path).to eq(item_path(@item))
      # エラーメッセージが表示されていることを確認（shared/_error_messages がある場合）
      expect(page).to have_content('商品名を入力してください')
    end
  end
end
