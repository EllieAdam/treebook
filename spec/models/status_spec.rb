require 'rails_helper'

RSpec.describe Status, :type => :model do
  describe "association" do
    it { should belong_to(:user) }
    it { should have_many(:comments) }
  end

  describe "validation" do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least 2 }

    it "accepts a status with an existing user assigned" do
      user = create(:user)
      status = Status.create(attributes_for(:status, user_id: user.id))
      expect(status).to be_valid
      status.valid?
      expect(status.errors[:user]).to be_empty
    end

    it "rejects a status with a nonexistent user assigned" do
      user = create(:user)
      status = Status.create(attributes_for(:status, user_id: 666))
      expect(status).to_not be_valid
      status.valid?
      expect(status.errors[:user]).to include('that actually exists must be assigned!')
    end
  end
end
