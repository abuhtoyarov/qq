require 'rails_helper'

feature 'User sign out', %q{
        In order to be able to sign out user
        As an user
        I want to be able to sign out
} do

  scenario 'Sign out' do
    User.create(email:'user1@test.com', password:'123456789')

    visit new_user_session_path
    fill_in 'Email', with:'user1@test.com'
    fill_in 'Password', with: '123456789'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end