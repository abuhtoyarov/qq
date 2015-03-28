require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saved the new question in the database' do
        expect{ post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect{ post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 're-render new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #index' do
    let(:question){ create_list(:question, 2 ) }

    before{ get :index }

    it 'populates an array of all question' do
      expect(assigns(:question)) .to match_array(question)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question){ create(:question)}

    before{ get :show, id: question }

    it 'Assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    before{ get :new }

    it 'Assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end
end
