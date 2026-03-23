class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ニックネームが含まれている
  validates :nickname, presence: true

  # パスワードが半角英数字とエラーメッセージ
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  validates_format_of :password, with: PASSWORD_REGEX, message: 'には英字と数字の両方を含めて設定してください'

  # 全角（漢字・ひらがな・カタカナ）の正規表現
  ZENKAKU_REGEX = /\A[ sterilityぁ-んァ-ヶ一-龥々ー]+\z/
  # 全角（カタカナ）の正規表現
  KANA_REGEX = /\A[ァ-ヶー]+\z/

  with_options presence: true do
    validates :nickname
    validates :birth_date
    # お名前(全角)のバリデーション
    validates :last_name, format: { with: ZENKAKU_REGEX, message: 'は全角（漢字・ひらがな・カタカナ）で入力してください' }
    validates :first_name, format: { with: ZENKAKU_REGEX, message: 'は全角（漢字・ひらがな・カタカナ）で入力してください' }
    # お名前カナ(全角)のバリデーション
    validates :last_name_kana, format: { with: KANA_REGEX, message: 'は全角（カタカナ）で入力してください' }
    validates :first_name_kana, format: { with: KANA_REGEX, message: 'は全角（カタカナ）で入力してください' }
  end
end
