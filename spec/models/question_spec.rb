require 'rails_helper'

RSpec.describe Question, type: :model do
  it{ should validate_presence_of :title }
  it{ should validate_presence_of :body }
  it{ should have_many :answers }
  it{ should have_many(:answers).dependent(:destroy) }
  it{ should have_many :attachments}
  it{ should have_many :subscribers}
  it{ should accept_nested_attributes_for :attachments }

  describe '.after_create' do
    let!(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'creates new email sub for author' do
      expect { question }.to change(user.subscribers, :count).by 1
    end
  end

end
