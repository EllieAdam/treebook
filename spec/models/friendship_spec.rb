# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string
#
# Indexes
#
#  index_friendships_on_state                  (state)
#  index_friendships_on_user_id_and_friend_id  (user_id,friend_id)
#

require 'rails_helper'

RSpec.describe Friendship, :type => :model do
  let(:boss) { create(:user) }
  let(:worker) { create(:user) }

  describe "association" do
    it { should belong_to(:user) }
    it { should belong_to(:friend) }
  end

  describe "validation" do
    it { should validate_presence_of(:state) }

    it "accepts known relationship state" do
      friendship = Friendship.create(user_id: boss.id, friend_id: worker.id, state: 'pending')
      expect(friendship).to be_valid
      friendship.valid?
      expect(friendship.errors[:state]).to be_empty
    end

    it "rejects unknown relationship state" do
      friendship = Friendship.create(user_id: boss.id, friend_id: worker.id, state: 'nice')
      expect(friendship).to_not be_valid
      friendship.valid?
      expect(friendship.errors[:state]).to include('nice is not a valid state!')
    end

    it "accepts a relationship with an existing user assigned" do
      friendship = Friendship.create(user_id: boss.id, friend_id: worker.id, state: 'pending')
      expect(friendship).to be_valid
      friendship.valid?
      expect(friendship.errors[:user]).to be_empty
    end

    it "rejects a relationship with a nonexistent user assigned" do
      friendship = Friendship.create(user_id: 666, friend_id: worker.id, state: 'pending')
      expect(friendship).to_not be_valid
      friendship.valid?
      expect(friendship.errors[:user]).to include('that actually exists must be assigned!')
    end

    it "accepts a relationship with an existing friend assigned" do
      friendship = Friendship.create(user_id: boss.id, friend_id: worker.id, state: 'pending')
      expect(friendship).to be_valid
      friendship.valid?
      expect(friendship.errors[:friend]).to be_empty
    end

    it "rejects a relationship with a nonexistent friend assigned" do
      friendship = Friendship.create(user_id: boss.id, friend_id: 666, state: 'pending')
      expect(friendship).to_not be_valid
      friendship.valid?
      expect(friendship.errors[:friend]).to include('that actually exists must be assigned!')
    end
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

    it "sets the initial state of first friendship to pending" do
      Friendship.request(boss, worker)
      friendship = Friendship.where(user_id: boss.id).first
      expect(friendship.state).to eq("pending")
    end

    it "sets the initial state of second friendship to requested" do
      Friendship.request(boss, worker)
      friendship = Friendship.where(user_id: worker.id).first
      expect(friendship.state).to eq("requested")
    end

    #    it "sends a request email" do
    #      expect{Friendship.request(boss, worker)}.to change(ActionMailer::Base.deliveries, :size).by(1)
    #    end
  end

  describe "#block" do
    before do
      Friendship.request(boss, worker)
    end

    it "changes friendship's state from requested to blocked" do
      friendship = Friendship.where(user_id: worker.id).first
      friendship.block!
      friendship.reload
      expect(friendship.state).to eq("blocked")
    end

    it "changes friendship's state from pending to blocked" do
      friendship = Friendship.where(user_id: boss.id).first
      friendship.block!
      friendship.reload
      expect(friendship.state).to eq("blocked")
    end

    it "changes friendship's state from accepted to blocked" do
      friendship = Friendship.where(user_id: worker.id).first
      friendship.accept!
      friendship.reload
      expect(friendship.state).to eq("accepted")
      friendship.block!
      friendship.reload
      expect(friendship.state).to eq("blocked")
    end

    it "does not allow forming new friendships" do
      friendship = Friendship.where(user_id: boss.id).first
      friendship.block!
      friendship.reload
      uf = Friendship.request(boss, worker)
      expect(uf.save).to eq(false)
    end
  end

  describe "#accept" do
    before do
      Friendship.request(boss, worker)
    end

    it "changes friendship's state to accepted" do
      friendship2 = Friendship.where(user_id: worker.id).first
      friendship2.accept!
      friendship2.reload
      expect(friendship2.state).to eq("accepted")
    end
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

  describe "#delete_mutual_friendship!" do
    it "deletes the mutual frienship when the first one is destroyed" do
      Friendship.request(boss, worker)
      expect(Friendship.count).to eq(2)
      friendship1 = boss.friendships.where(friend_id: worker.id).first
      friendship2 = worker.friendships.where(friend_id: boss.id).first
      friendship1.destroy
      expect(Friendship.count).to eq(0)
    end

    it "deletes the mutual frienship when the second one is destroyed" do
      Friendship.request(boss, worker)
      expect(Friendship.count).to eq(2)
      friendship1 = boss.friendships.where(friend_id: worker.id).first
      friendship2 = worker.friendships.where(friend_id: boss.id).first
      friendship2.destroy
      expect(Friendship.count).to eq(0)
    end
  end

  describe "#block_mutual_friendship!" do
    it "blocks the mutual frienship when the first one is blocked" do
      Friendship.request(boss, worker)
      friendship1 = boss.friendships.where(friend_id: worker.id).first
      friendship2 = worker.friendships.where(friend_id: boss.id).first
      friendship1.block_mutual_friendship!
      friendship2.reload
      expect(friendship2.state).to eq("blocked")
    end

    it "blocks the mutual frienship when the second one is blocked" do
      Friendship.request(boss, worker)
      friendship1 = boss.friendships.where(friend_id: worker.id).first
      friendship2 = worker.friendships.where(friend_id: boss.id).first
      friendship2.block_mutual_friendship!
      friendship1.reload
      expect(friendship1.state).to eq("blocked")
    end
  end
end
