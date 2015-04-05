class StatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :all_statuses, only: [:index, :create, :update, :destroy]
  before_action :set_status, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :owner?, only: [:edit, :update, :destroy]
  before_action :is_blocked?, only: [:show, :upvote, :downvote]
  before_action :load_activities, only: [:index, :create, :update, :destroy, :upvote, :downvote]

  respond_to :html, :js

  def index
    respond_with(@statuses)
  end

  def show
    @comments = @status.comments.all.includes(:user)
    respond_with(@status)
  end

  def new
    @status = current_user.statuses.new
    respond_with(@status)
  end

  def edit
  end

  def create
    @status = current_user.statuses.new(status_params)
    unless @status.save
      render action: 'new'
    end
  end

  def update
    unless @status.update(status_params)
      render action: 'edit'
    end
  end

  def destroy
    unless @status.destroy
      redirect_to statuses_path, error: 'Status could not be deleted.'
    end
  end

  def upvote
    Status.public_activity_off
    if current_user.voted_up_on? @status
      @status.unliked_by current_user
      Status.public_activity_on
      @status.create_activity :unupvote
    else
      @status.upvote_by current_user
      Status.public_activity_on
      @status.create_activity :upvote
    end
  end

  def downvote
    Status.public_activity_off
    if current_user.voted_down_on? @status
      @status.undisliked_by current_user
      Status.public_activity_on
      @status.create_activity :undownvote
    else
      @status.downvote_by current_user
      Status.public_activity_on
      @status.create_activity :downvote
    end
  end

  private

  def load_activities
    @activities = PublicActivity::Activity.order('created_at DESC').limit(20).includes(:owner).includes(:trackable)
  end

  def all_statuses
    # Omit all statuses created by current user's list of blocked users
    if current_user.blocked_friends.any?
      @blocked_user_ids = current_user.blocked_friends.pluck(:id)
      @statuses = Status.where('user_id NOT IN (?)', @blocked_user_ids).page(params[:page]).order('id DESC').includes(:user)
    else
      @statuses = Status.page(params[:page]).order('id DESC').includes(:user)
    end
  end

  def set_status
    @status = Status.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:content)
  end

  def owner?
    unless @status.user == current_user || current_user.admin == true
      redirect_to statuses_path, error: "You are not allowed to do that"
    end
  end

  def is_blocked?
    redirect_to statuses_path, error: "Can't interact with blocked user's statuses." if current_user.has_blocked?(@status.user)
  end
end
