require_relative 'acceptance_helper'

feature 'Create answer on question', %q{
        In order to help user
        As an any user
        I want to be able create answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }


  scenario 'Non-authenticated user ties to created answer' do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Answer')
  end

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Answer on question'
    click_on 'Answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Answer on question'
    end
  end

  scenario 'Authenticated user creates blank answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content("Body can't be blank")
  end
end