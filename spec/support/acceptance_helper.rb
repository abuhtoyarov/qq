module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    within '.new_user' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end
  end

  def auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
        provider: 'twitter',
        uid: '123545'
    )

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: '123545',
        info: { email: 'test@facebook.com' }
    )
  end

end