require_relative "acceptance_helper"

feature 'Delete attachments from question', %q{
        In order to be able delete attachments from question
        As an author question
        I want to be able add attachments to question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question_with_attach, user: user) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'Authenticated user (Author question) delete two attachments from question', js: true do
    click_on 'Edit'

    all('.edit_question .fields').each { |file| file.click_on 'Remove this file' }

    click_on 'Save'

    expect(page).to_not have_link 'file.rb'
  end
end