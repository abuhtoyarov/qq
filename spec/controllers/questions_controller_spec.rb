require_relative '../../spec/acceptance/acceptance_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'POST #create' do
    sign_in_user
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
    let(:question){ create_list(:question, 2) }

    before{ get :index }

    it 'populates an array of all question' do
      expect(assigns(:question)).to match_array(question)
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
    sign_in_user
    before{ get :new }

    it 'Assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:question) { create(:question) }

    it 'Delete question' do
      question
      expect{ delete :destroy, id: question }.to change(Question, :count).by(-1)
    end

    it 'Redirect index page' do
      delete :destroy, id: question
      expect(response).to redirect_to root_path
    end

  end

  describe 'PATCH #update' do
    sign_in_user

    let!(:question) { create(:question) }

    it 'assigns the requested question to @question' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: question, question: {title: 'New Title', body: 'New body'}, format: :js
      question.reload
      expect(question.title).to eq 'New Title'
      expect(question.body).to eq 'New body'
    end

    it 'render update template' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(response).to render_template :update
    end
  end
end
