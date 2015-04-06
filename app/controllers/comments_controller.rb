class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_status
  before_action :load_activities

  respond_to :html

  def create
    @comment = @status.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      @comment.create_activity :create, owner: current_user, recipient: @comment.status
      redirect_to @status, notice: "Comment added"
    else
      redirect_to @status, error: "Something went wrong"
    end
  end

  def destroy
    @comment = @status.comments.find(params[:id])

    unless @comment.user == current_user || current_user.admin == true
      redirect_to @status, error: "You are not allowed to do that"
    end

    @comment.create_activity :destroy, owner: current_user, recipient: @comment.status

    if @comment.destroy
      redirect_to @status, notice: "Comment removed"
    else
      redirect_to @status, error: "Something went wrong"
    end
  end

  private

  def load_activities
    @activities = PublicActivity::Activity.order('created_at DESC').limit(15).includes(:owner).includes(:recipient)
  end

  def set_status
    @status = Status.find(params[:status_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
