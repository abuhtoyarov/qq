require_relative 'acceptance_helper'

feature 'Comment editing', %q{
        In order to fix mistake
        As an author of comment
        I`d like ot be able to edit my comment`
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user ) }
  given!(:comment_question) { create(:comment, commentable: question, user: user) }
  given!(:comment_answer) { create(:comment, commentable: answer, user: user) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    within '.question .comments' do
      expect(page).to_not have_link 'edit comment'
    end
  end

  describe 'Authenticated user (author)' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'User sees link Edit' do
      within '.question .comments' do
        expect(page).to have_link 'edit comment'
      end
    end

    scenario 'Try to edit his answer', js: true do
      within '.question .comments' do
        click_on 'edit comment'
        fill_in 'Comment', with: 'new comment test'
        click_on 'Save comment'

        expect(page).to_not have_content 'comment_question.body'
        expect(page).to have_content 'new comment test'
      end
    end
  end

  describe 'Authenticated user (author)' do
    before do
      sign_in other_user
      visit question_path(question)
    end

    scenario 'User sees link Edit' do
      within '.question .comments' do
        expect(page).to_not have_link 'edit comment'
      end
    end
  end
end