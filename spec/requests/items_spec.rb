require 'rails_helper'

RSpec.describe 'Items', type: :request do
  describe 'GET /items/new' do
    it 'ログインしていないユーザーはログイン画面にリダイレクトされる' do
      get new_item_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
