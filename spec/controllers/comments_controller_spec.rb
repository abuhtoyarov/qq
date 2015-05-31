require_relative '../../spec/acceptance/acceptance_helper'

RSpec.describe CommentsController, type: :controller do

  let!(:user) { create(:user) }
  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:comment_answer) { create(:comment, commentable: answer,  user: author) }
  let!(:comment_question) { create(:comment, commentable: question, user: author) }


  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saved the new comment in the database' do
        expect { post :create, commentable: 'answers', answer_id: answer, comment: attributes_for(:comment), format: :js }.to change(answer.comments, :count).by(1)
        expect { post :create, commentable: 'questions', question_id: question, comment: attributes_for(:comment), format: :js }.to change(question.comments, :count).by(1)
      end

      it 'Comment associated with commentable' do
        post :create, commentable: 'answers', answer_id: answer, comment: attributes_for(:comment), format: :js
        expect(assigns(:comment)[:commentable_id]).to eq answer.id

        post :create, commentable: 'questions', question_id: question, comment: attributes_for(:comment), format: :js
        expect(assigns(:comment)[:commentable_id]).to eq question.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :create, commentable: 'answers', answer_id: answer, comment: { body:nil }, format: :js }.to_not change(answer.comments, :count)
        expect { post :create, commentable: 'questions', question_id: question, comment: { body:nil }, format: :js }.to_not change(question.comments, :count)
      end
    end

  end

  describe 'DELETE #destroy' do
    sign_in_user
    context 'an author' do
      before{comment_answer.update(user_id: @user.id)
             comment_question.update(user_id: @user.id)  }

      it 'Delete answer' do
        expect { delete :destroy, id: comment_answer, format: :js }.to change(Comment, :count).by(-1)
        expect { delete :destroy, id: comment_question, format: :js }.to change(Comment, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, id: comment_answer, format: :js
        expect(response).to render_template :destroy

        delete :destroy, id: comment_question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'non-author' do
      it 'Delete answer' do
        expect { delete :destroy, id: comment_answer, format: :js }.to_not change(Comment, :count)
        expect { delete :destroy, id: comment_question, format: :js }.to_not change(Comment, :count)
        expect(response).to be_forbidden
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'an author' do

      before{comment_answer.update(user_id: @user.id)
      comment_question.update(user_id: @user.id)  }

      it 'assigns the requested comment to @comment' do
        patch :update, id: comment_answer, comment: attributes_for(:comment), format: :js
        expect(assigns(:comment)).to eq comment_answer
      end

      it 'changes comment attributes' do
        patch :update, id: comment_answer, comment: { body:'new comment' }, format: :js
        patch :update, id: comment_question, comment: { body:'new comment' }, format: :js
        comment_answer.reload
        expect(comment_answer.body).to eq 'new comment'
        comment_question.reload
        expect(comment_question.body).to eq 'new comment'
      end

      it 'render update template' do
        patch :update, id: comment_answer, comment: attributes_for(:comment), format: :js
        expect(response).to render_template :update
      end

    end

    context 'non-author' do
      it 'changes comment attributes' do
        patch :update, id: comment_answer, comment: { body:'new comment' }, format: :js
        patch :update, id: comment_question, comment: { body:'new comment' }, format: :js
        comment_answer.reload
        expect(comment_answer.body).to_not eq 'new comment'
        comment_question.reload
        expect(comment_question.body).to_not eq 'new comment'
        expect(response).to be_forbidden
      end
    end
  end

end
