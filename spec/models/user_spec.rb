require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user) # テストデータの準備
  end

  describe 'ユーザー新規登録' do
    context '新規登録できるとき' do
      it 'すべての値が正しく入力されていれば登録できる' do
        expect(@user).to be_valid
      end
    end

    context '新規登録できないとき' do
      # 必須チェックのテスト
      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('ニックネームを入力してください')
      end

      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールを入力してください')
      end

      # 一意性のテスト
      it '重複したemailが存在する場合登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールはすでに存在します')
      end

      # フォーマットのテスト
      it 'emailに@を含まない場合は登録できない' do
        @user.email = 'testmail.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールは不正な値です')
      end

      # パスワードの長さ・混合のテスト
      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードを入力してください')
      end
      it 'passwordが5文字以下では登録できない' do
        @user.password = '00000'
        @user.password_confirmation = '00000'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end

      it 'passwordが英語のみでは登録できない' do
        @user.password = 'abcdef'
        @user.password_confirmation = 'abcdef'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードには英字と数字の両方を含めて設定してください')
      end

      it 'passwordが数字のみでは登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードには英字と数字の両方を含めて設定してください')
      end

      it 'passwordに全角文字を含むと登録できない' do
        @user.password = 'ａbc123' # 全角の「ａ」
        @user.password_confirmation = 'ａbc123'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードには英字と数字の両方を含めて設定してください')
      end

      # 一致確認のテスト
      it 'passwordとpassword_confirmationが不一致では登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '1234567'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end

      it 'last_nameが空では登録できない' do
        @user.last_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('お名前(全角)を入力してください')
      end

      it 'last_nameが全角（漢字・ひらがな・カタカナ）以外では登録できない' do
        @user.last_name = 'abc'
        @user.valid?
        expect(@user.errors.full_messages).to include('お名前(全角)は全角（漢字・ひらがな・カタカナ）で入力してください')
      end

      it 'last_name_kanaが空では登録できない' do
        @user.last_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('お名前カナ(全角)を入力してください')
      end

      it 'last_name_kanaが全角（カタカナ）以外では登録できない' do
        @user.last_name_kana = 'あいう'
        @user.valid?
        expect(@user.errors.full_messages).to include('お名前カナ(全角)は全角（カタカナ）で入力してください')
      end

      # 名（漢字・ひらがな・カタカナ）のテスト
      it 'first_nameが空では登録できない' do
        @user.first_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('お名前(全角)を入力してください')
      end

      it 'first_nameが全角（漢字・ひらがな・カタカナ）以外では登録できない' do
        @user.first_name = 'abc'
        @user.valid?
        expect(@user.errors.full_messages).to include('お名前(全角)は全角（漢字・ひらがな・カタカナ）で入力してください')
      end

      it 'first_name_kanaが空では登録できない' do
        @user.first_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('お名前カナ(全角)を入力してください')
      end

      it 'first_name_kanaが全角（カタカナ）以外では登録できない' do
        @user.first_name_kana = 'あいう'
        @user.valid?
        expect(@user.errors.full_messages).to include('お名前カナ(全角)は全角（カタカナ）で入力してください')
      end

      it 'birth_dateが空では登録できない' do
        @user.birth_date = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('生年月日を入力してください')
      end
    end
  end
end
