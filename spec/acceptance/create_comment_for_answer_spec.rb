require_relative 'acceptance_helper'

feature 'Create comment on answer', %q{
        In order to help user
        As an authenticated user
        I want to be able create comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user ) }

  scenario 'Authenticated user creates comment', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Comment', with: 'new comment'
    click_on 'Add comment'

    expect(current_path).to eq question_path(question)

    within '.answers .comments' do
      expect(page).to have_content 'new comment'
    end
  end

end

