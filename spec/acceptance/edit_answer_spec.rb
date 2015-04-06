require_relative 'acceptance_helper'

feature 'Answer editing', %q{
        In order to fix mistake
        As an author of answer
        I`d like ot be able to edit my answer`
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user ) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'User sees link Edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'Try to edit his answer', js: true do
      within '.answers' do
        save_and_open_page
        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario "User try to edit other user`s question`" do
    sign_in other_user
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
