require_relative 'acceptance_helper'

feature 'Question editing', %q{
        In order to fix mistake
        As an author of question
        I`d like ot be able to edit my question`
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'User sees link Edit' do
      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'Try to edit his answer', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario "User try to edit other user`s question`" do
    sign_in other_user
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
end