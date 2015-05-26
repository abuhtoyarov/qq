require_relative 'acceptance_helper'

feature 'User sign in', %q{
        In order to be able to ask question
        As an user
        I want to be able to sign in
} do

  given!(:user) { create(:user) }

  before do
    auth_hash
  end

  scenario 'Login with facebook' do
    visit new_user_session_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario 'Login with twitter' do
    visit new_user_session_path
    click_on 'Sign in with Twitter'
    fill_in 'auth[info][email]', with: user.email
    click_on 'Complete'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  scenario "authentication error" do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    visit new_user_session_path
    click_on "Sign in with Twitter"

    expect(page).to have_content('Could not authenticate you from Twitter')
  end
end