require_relative "acceptance_helper"

feature 'Delete attachments from answer', %q{
        In order to be able delete attachments from answer
        As an author answer
        I want to be able add attachments to answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer_with_attach, question: question, user: user) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'Authenticated user (Author answer) delete attachments from answer', js: true do
    within '.answers' do
      click_on 'Edit'
    end
    click_on 'Remove this file'

    click_on 'Save'
    within '.answers' do
      expect(page).to_not have_link 'file.rb'
    end
  end
end