require_relative 'acceptance_helper'

feature 'User registration', %q{
        In order to be able to use all feature application
        As an user
        I want to be able sign up
} do

  scenario 'Registration successfully' do
    visit new_user_registration_path

    expect{fill_in 'Email', with:'user@test.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: "123456789"
    click_on 'Sign up'
    }.to change(User, :count).by(1)

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registration not successfully' do
    visit new_user_registration_path

    expect{fill_in 'Email', with:'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: "wrong"
    click_on 'Sign up'
    }.to_not change(User, :count)
  end

end