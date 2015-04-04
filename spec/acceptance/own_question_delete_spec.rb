require_relative 'acceptance_helper'

feature 'Owner may delete question', %q{
        In order to be able delete of question
        As an owner
        I want to be able delete of question
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Owner delete question' do
    sign_in user

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Question deleted'
  end

  scenario 'Non-Owner delete question' do
    sign_in wrong_user

    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Delete')
  end

  scenario 'Non authenticated user want delete question' do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Delete')
  end

end