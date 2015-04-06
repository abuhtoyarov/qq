require_relative 'acceptance_helper'

feature 'View question and answer', %q{
        In order to read answers on question
        As any user
        I want to be able view answers on question
} do
  scenario 'View question and answers on this question', js:true do
    question=Question.create(title:'Question title', body:'Question body')
    Answer.create question: question, body:'Answer body'

    visit questions_path
    click_on 'Question title'

    expect(page).to have_content "Answer body"
  end
end

