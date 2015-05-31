require_relative '../../spec/acceptance/acceptance_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      let(:channel) { '/index' }
      let(:params) {{ question: attributes_for(:question) }}

      it 'saved the new question in the database' do
        expect{ post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it_behaves_like "PrivatePub publishable"

    end

    context 'with invalid attributes' do
      let(:channel) { '/index' }
      let(:params) {{ question: attributes_for(:invalid_question) }}

      it 'does not save the question' do
        expect{ post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 're-render new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end

      it_behaves_like "PrivatePub not publishable"

    end

    def do_request
      post :create, params
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

    it 'Delete question' do
      question.update(user_id:@user.id)
      expect{ delete :destroy, id: question.id }.to change(Question, :count).by(-1)
    end

    it 'Redirect index page' do
      delete :destroy, id: question
      expect(response).to redirect_to root_path
    end

  end

  describe 'PATCH #update' do
    sign_in_user

    it 'assigns the requested question to @question' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      question.update(user_id:@user.id)
      patch :update, id: question, question: { title: 'new title', body: 'new body'}
      question.reload
      expect(question.title).to eq 'new title'
      expect(question.body).to eq 'new body'
    end

    it 'render update template' do
      question.update(user_id:@user.id)
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(response).to render_template :update
    end

    it 'Like question' do
      patch :like, id: question, question: attributes_for(:question), format: :js
      question.reload
      expect(question.rating).to eq 1
    end

    it 'DisLike question' do
      patch :dislike, id: question, question: attributes_for(:question), format: :js
      question.reload
      expect(question.rating).to eq -1
    end

    it 'Unvote question' do
      patch :like, id: question, question: attributes_for(:question), format: :js
      expect(question.rating).to eq 1
      patch :unvote, id: question, question: attributes_for(:question), format: :js
      question.reload
      expect(question.rating).to eq 0
    end

    it 'Retry like question' do
      patch :like, id: question, question: attributes_for(:question), format: :js
      question.reload
      expect(question.rating).to eq 1
      patch :like, id: question, question: attributes_for(:question), format: :js
      question.reload
      expect(question.rating).to eq 1
    end

    it 'Retry dislike question' do
      patch :dislike, id: question, question: attributes_for(:question), format: :js
      question.reload
      expect(question.rating).to eq -1
      patch :dislike, id: question, question: attributes_for(:question), format: :js
      question.reload
      expect(question.rating).to eq -1
    end
  end
end
