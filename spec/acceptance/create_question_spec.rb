require 'rails_helper'

feature 'Create question', %q{
        In order to get answer from community
        As an authenticated user
        I want to be able ask questions
} do

  given(:user) { create(:user) }


  scenario 'Authenticated user creates questions' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with:'Title question'
    fill_in 'Body', with:'body text'
    click_on 'Create question'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Title question'
    expect(page).to have_content 'body text'

  end

  scenario 'Non-authenticated user ties to created questions' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end