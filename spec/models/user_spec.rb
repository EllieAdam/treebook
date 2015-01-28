require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "relationships" do
    it { should have_many(:statuses) }
    it { should have_many(:friendships) }
    it { should have_many(:friends) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
