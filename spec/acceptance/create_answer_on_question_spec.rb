require 'rails_helper'

feature 'Create answer on question', %q{
        In order to help user
        As an any user
        I want to be able create answer
} do

  scenario 'Non-authenticated user ties to created answer' do
    Question.create(title:'Question title', body:'Question body')
    visit questions_path

    save_and_open_page
    click_on 'Question title'
    fill_in 'Body', with: 'Answer on question'
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created.'

  end

end