require 'rails_helper'

feature 'Create question', %q{
        In order to get answer from community
        As an authenticated user
        I want to be able ask questions
} do

  scenario 'Non-authenticated user ties to created questions' do
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with:'Title question'
    fill_in 'Body', with:'body text'
    click_on 'Create question'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Title question'
    expect(page).to have_content 'body text'

  end

end