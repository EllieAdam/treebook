class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.friendly.find(params[:id])
    @statuses = @user.statuses.order('created_at desc')
  end
end
