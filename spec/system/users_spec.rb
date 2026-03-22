require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ログアウト状態のとき' do
    it 'トップページに「新規登録」「ログイン」ボタンが表示される' do
      visit root_path

      expect(page).to have_content('新規登録')
      expect(page).to have_content('ログイン')
    end

   context 'ログイン状態のとき' do
    it 'トップページに「ニックネーム」と「ログアウト」ボタンが表示される' do
      # 事前にユーザーをDBに保存
      @user.save
      
      # ログインページへ遷移
      visit new_user_session_path
      
      # ログイン情報を入力
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      
      # ログインボタン（送信ボタン）をクリック
      find('input[name="commit"]').click
      
      # トップページに遷移したことを確認
      expect(page).to have_current_path(root_path)

      # ニックネームとログアウトボタンがあるか確認
      expect(page).to have_content(@user.nickname)
      expect(page).to have_content('ログアウト')

      # 新規登録とログインボタンがないことを確認
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  end
end
