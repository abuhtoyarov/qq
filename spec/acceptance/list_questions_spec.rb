require_relative 'acceptance_helper'

feature 'View questions', %q{
        In order to find answer on question
        As an any user
        I want view lists of questions
} do

  given!(:question) { create_list(:question, 2) }

  scenario 'Any user may view the list of questions' do

    visit questions_path

    question.each { |q| expect(page).to have_content q.title }

  end

end