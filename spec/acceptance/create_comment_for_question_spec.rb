require_relative 'acceptance_helper'

feature 'Create comment on question', %q{
        In order to help user
        As an authenticated user
        I want to be able create comment
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user creates comment', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'add a comment'
    fill_in 'Comment', with: 'new comment'
    click_on 'Add comment'

    expect(current_path).to eq question_path(question)

    within '.question .comments' do
      expect(page).to have_content 'new comment'
    end
  end

  scenario 'Non-authenticated user ties to created comment' do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'add a comment')
  end

  scenario 'Authenticated user creates blank comment', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'add a comment'
    click_on 'Add comment'

    expect(page).to have_content("Body can't be blank")
  end


end

