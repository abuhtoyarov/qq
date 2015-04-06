require_relative 'acceptance_helper'

feature 'Best answers', %q{
        In order to set best answer
        As an author question
        I want to be able to choose the best answer
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user ) }

  scenario 'Author question accept the best answer', js: true do
    sign_in user

    visit question_path(question)

    click_on 'Accept'

    visit question_path(question)

    within '.panel-success' do
      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Accept'
    end
  end
end