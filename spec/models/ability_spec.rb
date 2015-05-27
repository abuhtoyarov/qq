require 'rails_helper'

describe Ability do
  subject(:ability){ Ability.new(user)}

  describe 'for guest' do
    let(:user){ nil }

    it {should be_able_to :read, Question}
    it {should be_able_to :read, Answer}
    it {should be_able_to :read, Comment}

    it {should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) {create(:user, admin: true)}

    it {should be_able_to :manage, :all}
  end

  describe 'for user' do
    let(:user){ create(:user) }
    let(:other){ create(:user) }
    let(:other_answer) { create :answer }
    let(:answer) { create :answer }
    let(:voted_answer) { other_answer.liked_by user; other_answer }
    let(:other_question) { create :question }
    let(:question) { create :question, user: user }
    let(:answer_in_question) { create :answer, question:question }
    let(:voted_question) { other_question.liked_by user; other_question }


    it {should be_able_to :read, :all}
    it {should_not be_able_to :manage, :all}

    it {should be_able_to :create, Question}
    it {should be_able_to :create, Answer}
    it {should be_able_to :create, Comment}

    it {should be_able_to :update, create(:question, user: user), user: user}
    it {should_not be_able_to :update, create(:question, user: other), user: user}

    it {should be_able_to :update, create(:answer, user: user), user: user}
    it {should_not be_able_to :update, create(:answer, user: other), user: user}

    it {should be_able_to :update, create(:comment, user: user), user: user}
    it {should_not be_able_to :update, create(:comment, user: other), user: user}

    it {should be_able_to :destroy, create(:question, user: user), user: user}
    it {should_not be_able_to :destroy, create(:question, user: other), user: user}

    it {should be_able_to :destroy, create(:answer, user: user), user: user}
    it {should_not be_able_to :destroy, create(:answer, user: other), user: user}

    it {should be_able_to :destroy, create(:comment, user: user), user: user}
    it {should_not be_able_to :destroy, create(:comment, user: other), user: user}

    it {should be_able_to :like, create(:answer, user: other), user: user}
    it {should_not be_able_to :like, create(:answer, user: user), user: user}

    it {should be_able_to :dislike, create(:answer, user: other), user: user}
    it {should_not be_able_to :dislike, create(:answer, user: user), user: user}

    it { should be_able_to :accept, answer_in_question }
    it { should_not be_able_to :accept, other_answer }

    it { should_not be_able_to :like, voted_answer }
    it { should_not be_able_to :like, voted_question }

    it { should_not be_able_to :dislike, voted_answer }
    it { should_not be_able_to :dislike, voted_question }

    it { should be_able_to :unvote, voted_answer }
    it { should be_able_to :unvote, voted_question }



  end
end