require_relative 'acceptance_helper'

feature 'Liked answer', %q{
        In order to set liked answer
        As an user
        I want to be able to choose the liked answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user ) }

  scenario 'Authenticated user (non author) try to liked answer', js: true do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      click_on 'up vote'
    end
    within '.answers .rating-sum' do
      expect(page).to have_content 1
    end
    within '.answers' do
      expect(page).to_not have_link 'up vote'
      expect(page).to_not have_link 'down vote'
      expect(page).to have_link 'un vote'
      expect(page).to have_content 'your vote1'
    end
  end

  scenario 'Authenticated user (non author) try to disliked answer', js: true do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      click_on 'down vote'
    end
    within '.answers .rating-sum' do
      expect(page).to have_content -1
    end
    within '.answers' do
      expect(page).to_not have_link 'up vote'
      expect(page).to_not have_link 'down vote'
      expect(page).to have_link 'un vote'
      expect(page).to have_content 'your vote-1'
    end
  end

  scenario 'Authenticated user (non author) try to cancel vote answer', js: true do
    sign_in(other_user)
    visit question_path(question)

    within '.answers' do
      click_on 'up vote'
    end
    within '.answers .rating-sum' do
      expect(page).to have_content 1
    end
    within '.answers' do
      click_on 'un vote'
    end
    within '.answers .rating-sum' do
      expect(page).to have_content 0
    end
    within '.answers' do
      expect(page).to have_link 'up vote'
      expect(page).to have_link 'down vote'
      expect(page).to_not have_link 'un vote'
    end
  end

  scenario 'Authenticated user (author) try to liked answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'up vote'
    end
    within '.answers .rating-sum' do
      expect(page).to have_content 0
    end
    within '.answers' do
      expect(page).to have_content 'The author can not vote.'
    end
  end

end