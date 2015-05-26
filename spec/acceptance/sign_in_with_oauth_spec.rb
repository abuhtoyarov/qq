require_relative 'acceptance_helper'

feature 'User sign in', %q{
        In order to be able to ask question
        As an user
        I want to be able to sign in
} do

  given!(:existing_user) { create(:user) }

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

    expect(page).to have_content 'Please fill in the email to complete authorization'

    fill_in 'auth[info][email]', with: 'tw@test.com'
    click_on 'Complete'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
    expect(current_path).to eq root_path

    click_on 'Log out'
    click_on 'Ask question'
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
    expect(current_path).to eq new_question_path
  end

  scenario 'Login from twitter with exist email' do
    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Please fill in the email to complete authorization'

    fill_in 'auth[info][email]', with: existing_user.email
    click_on 'Complete'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
    expect(current_path).to eq root_path

    click_on 'Log out'
    click_on 'Ask question'
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
    expect(current_path).to eq new_question_path
  end

  scenario "authentication error" do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    visit new_user_session_path
    click_on "Sign in with Twitter"

    expect(page).to have_content('Could not authenticate you from Twitter')
  end



end