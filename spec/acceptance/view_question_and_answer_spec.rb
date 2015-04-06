require_relative 'acceptance_helper'

feature 'View question and answer', %q{
        In order to read answers on question
        As any user
        I want to be able view answers on question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user ) }

  scenario 'Non-authenticated user may view question and answers on this question', js:true do
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

  scenario 'Authenticated user may view question and answers on this question', js:true do
    sign_in user

    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

end

