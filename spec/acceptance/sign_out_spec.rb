require_relative 'acceptance_helper'

feature 'User sign out', %q{
        In order to be able to sign out user
        As an user
        I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Sign out' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end