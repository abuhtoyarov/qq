require_relative 'acceptance_helper'

feature 'Best answers', %q{
        In order to set best answer
        As an author question
        I want to be able to choose the best answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:accepted_answer) { create(:answer, question: question, user: user, body: "Accepted answer", best:true ) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user ) }


  scenario 'Accepted answer first in list answers on page', js: true do
    sign_in user

    visit question_path(question)
    within "#answer#{answer.id}" do
      click_on 'Accept'
    end

    first_answer_on_page = page.first(:css, '.answers .row')
    expect(page).to have_selector('.answer', count: 4)
    expect(first_answer_on_page).to have_content answer.body
  end

  scenario 'Authenticated (Author question) user mark choose other answer as accepted ', js: true do
    sign_in user
    accepted_answer

    visit question_path(question)
     within "#answer#{answer.id}" do
      click_on 'Accept'
    end

    within ".panel-success}" do
      expect(page).to have_content answer.body
      expect(page).to_not have_content accepted_answer.body
    end

    first_answer_on_page = page.first(:css, '.answers .row')

    expect(first_answer_on_page).to have_content answer.body

  end

  scenario 'Authenticated user (Author) mark the answer as accepted', js: true do
    sign_in user

    visit question_path(question)
    within "#answer#{answer.id}" do
      click_on 'Accept'
    end

    expect(page).to have_selector('.panel-success')
  end

  scenario 'Non-authenticated user not sees link accept', js: true do
    visit question_path(question)

    within "#answer#{answer.id}" do
      expect(page).to_not have_link 'Accept'
    end
  end

  scenario 'Authenticated user (non-author question) not sees link accept', js: true do
    sign_in other_user
    visit question_path(question)

    within "#answer#{answer.id}" do
      expect(page).to_not have_link 'Accept'
    end
  end
end
