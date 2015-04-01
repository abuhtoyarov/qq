require 'rails_helper'

feature 'Owner may delete question or answer', %q{
        In order to be able delete of question or answer
        As an owner
        I want to be able delete of question ot answer
} do

  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Owner delete question' do
    sign_in user

    visit question_path(question)
    save_and_open_page
    click_on 'Delete'

    expect(page).to have_content 'Question deleted'
  end

  scenario 'Non-Owner delete answer' do
    sign_in wrong_user

    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Delete')

  end

end