require 'rails_helper'

RSpec.describe '商品情報編集', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @seller = @item.user
    @user = FactoryBot.create(:user)
  end

  # ログインメソッド
  def login(user)
    visit new_user_session_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    find('.login-red-btn').click
    expect(page).to have_current_path(root_path, wait: 10)
  end

  context '商品編集画面へ遷移できるとき' do
    it 'ログイン状態の出品者は、自身が出品した販売中商品の編集ページに遷移できる' do
      login(@seller)
      expect(page).to have_content('ログアウト')

      visit item_path(@item)

      # expect(page).to have_link('商品の編集', href: "/items/#{@item.id}/edit")
      expect(page).to have_link('商品の編集', href: edit_item_path(@item))
      click_link '商品の編集'
      expect(page).to have_current_path(edit_item_path(@item), wait: 10)
      # expect(current_path).to eq(edit_item_path(@item))
    end
  end

  context '商品編集画面へ遷移できないとき' do
    it 'ログイン状態でも、自身が出品していない商品の編集ページへ遷移しようとすると、トップページに遷移する' do
      login(@user)
      visit edit_item_path(@item)
      expect(current_path).to eq(item_path(@item))
    end

    it '内容に不備がある（空欄など）場合は編集に失敗し、編集画面に戻る' do
      login(@seller)
      visit edit_item_path(@item)
      fill_in 'item-name', with: ''
      click_on '変更する'
      expect(current_path).to eq(edit_item_path(@item))
      # expect(current_path).to eq("/items/#{@item.id}")
      expect(page).to have_content('商品名を入力してください')
    end
  end
end
