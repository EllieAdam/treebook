require 'rails_helper'

RSpec.describe Friendship, :type => :model do
  let(:boss) { create(:user) }
  let(:worker) { create(:user) }

  describe "has proper model relationships" do
    it { should belong_to(:user) }
    it { should belong_to(:friend) }
  end

  describe "frienship manipulation" do
    it "frienship creation does not raise any errors" do
      expect{ Friendship.create(user: boss, friend: worker) }.to_not raise_error
    end

    it "listing friends does not raise any errors" do
      expect{ boss.friends }.to_not raise_error
    end

    it "friends are added properly" do
      boss.friends << worker
      expect(boss.friends).to include(worker)
    end

    it "friendship creation works with ids" do
      Friendship.create(user_id: boss.id, friend_id: worker.id)
      expect(boss.friends).to include(worker)
    end
  end
end
