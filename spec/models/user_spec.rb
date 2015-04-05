# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string           default(""), not null
#  admin                  :boolean          default(FALSE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  slug                   :string
#  deleted_at             :datetime
#  image_file_name        :string
#  image_content_type     :string
#  image_file_size        :integer
#  image_updated_at       :datetime
#  provider               :string
#  uid                    :string
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "relationships" do
    it { should have_many(:statuses) }
    it { should have_many(:comments) }
    it { should have_many(:friendships) }
    it { should have_many(:friends) }
    it { should have_many(:pending_friendships) }
    it { should have_many(:pending_friends) }
    it { should have_many(:requested_friendships) }
    it { should have_many(:requested_friends) }
    it { should have_many(:blocked_friendships) }
    it { should have_many(:blocked_friends) }
    it { should have_many(:accepted_friendships) }
    it { should have_many(:accepted_friends) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
