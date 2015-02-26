# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :string
#  user_id    :integer
#  status_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Comment, :type => :model do
  describe "association" do
    it { should belong_to(:user) }
    it { should belong_to(:status) }
  end

  describe "validation" do
    it { should validate_presence_of(:body) }

    it "accepts a comment with an existing user assigned" do
      user = create(:user)
      status = user.statuses.create(attributes_for(:status))
      comment = status.comments.create(attributes_for(:comment, user_id: user.id))
      expect(comment).to be_valid
      comment.valid?
      expect(comment.errors[:user]).to be_empty
    end

    it "rejects a comment with a nonexistent user assigned" do
      user = create(:user)
      status = user.statuses.create(attributes_for(:status))
      comment = status.comments.create(attributes_for(:comment, user_id: 666))
      expect(comment).to_not be_valid
      comment.valid?
      expect(comment.errors[:user]).to include('that actually exists must be assigned!')
    end

    it "accepts a comment with an existing status assigned" do
      user = create(:user)
      status = user.statuses.create(attributes_for(:status))
      comment = user.comments.create(attributes_for(:comment, status_id: status.id))
      expect(comment).to be_valid
      comment.valid?
      expect(comment.errors[:status]).to be_empty
    end

    it "rejects a comment with a nonexistent status assigned" do
      user = create(:user)
      status = user.statuses.create(attributes_for(:status))
      comment = user.comments.create(attributes_for(:comment, status_id: 666))
      expect(comment).to_not be_valid
      comment.valid?
      expect(comment.errors[:status]).to include('that actually exists must be assigned!')
    end
  end
end
