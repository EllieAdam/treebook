class ActivityFeedController < ApplicationController
  before_action :authenticate_user!

  def index
    @activities = PublicActivity::Activity.order('created_at DESC').includes(:owner).includes(:recipient).includes(:trackable)
  end
end
