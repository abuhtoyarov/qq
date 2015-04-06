require_relative 'acceptance_helper'

feature 'Owner may delete answer', %q{
        In order to be able delete of answer
        As an owner
        I want to be able delete of answer
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user ) }


  scenario 'Owner delete answer', js: true do
    sign_in user

    visit question_path(question)

    within '.answers' do
      click_link 'Delete answer'

      expect(page).to_not have_content answer.body
    end
  end

  scenario 'Non authenticated user want delete answer' do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Delete answer')
  end

  scenario 'Non-Owner answer question' do
    sign_in wrong_user

    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Delete answer')
  end
end