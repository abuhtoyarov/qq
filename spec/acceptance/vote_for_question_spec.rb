require_relative 'acceptance_helper'

feature 'Liked question', %q{
        In order to set liked question
        As an user
        I want to be able to choose the liked question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user (non author) try to liked question', js: true do
    sign_in(other_user)
    visit question_path(question)
    click_on 'up vote'
    within '.rating-sum' do
      expect(page).to have_content 1
    end
    expect(page).to_not have_link 'up vote'
    expect(page).to_not have_link 'down vote'
    expect(page).to have_link 'un vote'
    expect(page).to have_content 'your vote1'
  end

  scenario 'Authenticated user (non author) try to disliked question', js: true do
    sign_in(other_user)
    visit question_path(question)
    click_on 'down vote'
    within '.rating-sum' do
      expect(page).to have_content -1
    end
    expect(page).to_not have_link 'up vote'
    expect(page).to_not have_link 'down vote'
    expect(page).to have_link 'un vote'
    expect(page).to have_content 'your vote-1'
  end

  scenario 'Authenticated user (non author) try to cancel vote question', js: true do
    sign_in(other_user)
    visit question_path(question)
    click_on 'up vote'
    within '.rating-sum' do
      expect(page).to have_content 1
    end

    click_on 'un vote'
    within '.rating-sum' do
      expect(page).to have_content 0
    end

    expect(page).to have_link 'up vote'
    expect(page).to have_link 'down vote'
    expect(page).to_not have_link 'un vote'
  end


end