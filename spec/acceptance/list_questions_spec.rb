require 'rails_helper'

feature 'View questions', %q{
        In order to find answer on question
        As an any user
        I want view lists of questions
} do

  scenario 'Any user may view the list of questions' do
    Question.create(title: "question1", body: "question body1")
    Question.create(title: "question2", body: "question body2")

    visit questions_path

    expect(page).to have_content 'question1'
    expect(page).to have_content 'question2'

  end

end