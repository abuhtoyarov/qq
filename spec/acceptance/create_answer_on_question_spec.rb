require 'rails_helper'

feature 'Create answer on question', %q{
        In order to help user
        As an any user
        I want to be able create answer
} do

  given(:user) { create(:user) }

  scenario 'Non-authenticated user ties to created answer' do

  end

  scenario 'Authenticated user creates answer' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    Question.create(title:'Question title', body:'Question body')

    visit questions_path

    click_on 'Question title'
    fill_in 'Body', with: 'Answer on question'
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created.'
  end
end