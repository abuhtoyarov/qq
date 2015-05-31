require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) {create(:question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create :question }
      let!(:answers) { create_list(:answer,2, question:question) }
      let!(:answer) { question.answers.first}

      before{get api_v1_question_answers_path(question), format: :json, access_token: access_token.token}

      it_behaves_like "API successful"

      it 'returns list of answer' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get api_v1_question_answers_path(question), {format: :json}.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:answer) {create(:answer) }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachments) { create(:attachment, attachable: answer) }

      before{get api_v1_answer_path(answer), format: :json, access_token: access_token.token}

      it_behaves_like "API successful"

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it "include in answer object" do
            expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it "include in answer object" do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it "contains url" do
          puts
           expect(response.body).to be_json_eql(attachments.file.url.to_json).at_path("answer/attachments/0/url")
         end
      end
    end

    def do_request(options = {})
      get api_v1_question_answers_path(answer), {format: :json}.merge(options)
    end
  end

  describe 'POST /create' do
    let!(:question) { create :question }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:attr) { attributes_for :answer }
      let(:access_token) { create(:access_token) }
      let(:params) { { answer: attr, format: :json, access_token: access_token.token } }

      before{ post api_v1_question_answers_path(question), params }

      it_behaves_like "API successful"

      it 'answer created' do
        expect(response).to be_created
      end

      it 'answer saved in database' do
        expect{post api_v1_question_answers_path(question), params}.to change(Answer, :count).by(1)
      end
    end
  end

  def do_request(options = {})
    post api_v1_question_answers_path(question), {format: :json}.merge(options)
  end
end