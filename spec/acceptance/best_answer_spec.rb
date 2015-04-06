require_relative 'acceptance_helper'

feature 'Best answers', %q{
        In order to set best answer
        As an author question
        I want to be able to choose the best answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
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

    scenario 'Authenticated user sees Accept link' do
      sign_in user

      visit question_path(question)

      within '.panel-default' do
        expect(page).to have_content answer.body
        expect(page).to have_link 'Accept'
      end
    end

    scenario 'Non-Authenticated user not sees accept link' do
      visit question_path(question)

      within '.panel-default' do
        expect(page).to_not have_link 'Accept'
      end
    end

  scenario 'Authenticated (Non-Author) user not sees accept link' do
    sign_in other_user
    visit question_path(question)

    within '.panel-default' do
      expect(page).to_not have_link 'Accept'
    end
  end
end
