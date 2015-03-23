require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'POST #create' do
    context 'with valid attributes' do

      it 'saved the new question in the database' do
        expect{ post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'redirects to show view'


    end


  end
end
