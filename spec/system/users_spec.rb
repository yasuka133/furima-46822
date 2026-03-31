require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    @user = FactoryBot.build(:user)
    driven_by :rack_test
  end

  context 'ログアウト状態のとき' do
    it 'トップページに「新規登録」「ログイン」ボタンが表示される' do
      visit root_path

      expect(page).to have_content('新規登録')
      expect(page).to have_content('ログイン')
    end

    it '新規登録ボタンをクリックすると新規登録ページに遷移する' do
      # トップページに遷移する
      visit root_path
      # 新規登録ボタンをクリックする
      click_on '新規登録'
      # 新規登録ページに遷移したことを確認する
      expect(page).to have_current_path(new_user_registration_path)
    end

    it 'ログインボタンをクリックするとログインページに遷移する' do
      # トップページに遷移する
      visit root_path
      # ログインボタンをクリックする
      click_on 'ログイン'
      # ログインページに遷移したことを確認する
      expect(page).to have_current_path(new_user_session_path)
    end
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

    it 'ログアウトボタンをクリックするとログアウトができる' do
      @user.save
      # ログインする
      visit new_user_session_path
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      find('input[name="commit"]').click
      expect(page).to have_current_path(root_path)

      # ログアウトボタンをクリックする
      click_on 'ログアウト'

      # トップページに戻ってきたことを確認する
      expect(page).to have_current_path(root_path)

      # 画面内に「新規登録」「ログイン」ボタンが表示されていることを確認する
      expect(page).to have_content('新規登録')
      expect(page).to have_content('ログイン')

      # 画面内に「ログアウト」ボタンが表示されていないことを確認する
      expect(page).to have_no_content('ログアウト')
    end
  end
end
