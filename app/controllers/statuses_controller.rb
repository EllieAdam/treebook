class StatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :all_statuses, only: [:index, :create, :update, :destroy]
  before_action :set_status, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :owner?, only: [:edit, :update, :destroy]
  before_action :is_blocked?, only: [:show, :upvote, :downvote]
  before_action :load_activities, only: [:index, :show, :create, :update, :destroy, :upvote, :downvote]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_status

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
    if @status.save
      @status.create_activity :create, owner: current_user
    else
      render action: 'new'
    end
  end

  def update
    if @status.update(status_params)
      @status.create_activity :update, owner: current_user
    else
      render action: 'edit'
    end
  end

  def destroy
    @status.create_activity :destroy, owner: current_user
    unless @status.destroy
      redirect_to statuses_path, error: 'Status could not be deleted.'
    end
  end

  def upvote
    if current_user.voted_up_on? @status
      @status.unliked_by current_user
      @status.create_activity :unupvote, owner: current_user
    else
      @status.upvote_by current_user
      @status.create_activity :upvote, owner: current_user
    end
  end

  def downvote
    if current_user.voted_down_on? @status
      @status.undisliked_by current_user
      @status.create_activity :undownvote, owner: current_user
    else
      @status.downvote_by current_user
      @status.create_activity :downvote, owner: current_user
    end
  end

  private

  def load_activities
    @activities = PublicActivity::Activity.order('created_at DESC').limit(15).includes(:owner).includes(:recipient).includes(:trackable)
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

  def invalid_status
    redirect_to statuses_url, error: "Status not found"
  end
end
