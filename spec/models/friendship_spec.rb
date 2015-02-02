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
      expect(boss.pending_friends).to include(worker)
    end
  end

  describe ".request" do
    it "creates two friendships between users" do
      expect{Friendship.request(boss, worker)}.to change(Friendship, :count).by(2)
    end

#    it "sends a request email" do
#      expect{Friendship.request(boss, worker)}.to change(ActionMailer::Base.deliveries, :size).by(1)
#    end
  end

  describe "#accept_mutual_friendship!" do
    it "accepts the mutual frienship" do
      Friendship.request(boss, worker)
      friendship1 = boss.friendships.where(friend_id: worker.id).first
      friendship2 = worker.friendships.where(friend_id: boss.id).first
      friendship1.accept_mutual_friendship!
      friendship2.reload
      expect(friendship2.state).to eq("accepted")
    end
  end
end
