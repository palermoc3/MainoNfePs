require 'rails_helper'

RSpec.describe 'User Authentication', type: :request do
  let!(:user) { create(:user, email: 'testuser@example.com', password: 'password123') }

  describe 'User Sign In' do
    it 'signs user in' do
      expect(user_session_path).not_to be_nil

      # Sign in
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      expect(response).to have_http_status(:see_other) # Status 303
      follow_redirect!
      expect(response).to render_template(:index)
      expect(controller.current_user).to eq(user)
    end
  end

  describe 'User Sign Out' do
    it 'signs user out' do
      sign_in user
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path) # ou para onde você espera redirecionar
      follow_redirect!
      expect("Signed out successfully.")
    end
  end
end