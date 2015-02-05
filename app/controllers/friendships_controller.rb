class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :json

  def index
    @friendships = current_user.friendships
    respond_with @friendships
  end

  def accept
    @friendship = current_user.friendships.find(params[:id])
    if @friendship.accept!
      flash[:success] = "You are now friends with #{@friendship.friend.name}"
    else
      flash[:error] = 'Something went horribly wrong!'
    end
    redirect_to friendships_path
  end

  def edit
    @friendship = current_user.friendships.find(params[:id]).decorate
    @friend = @friendship.friend
  end

  def new
    if params[:friend_id]
      render file: 'public/404', status: :not_found unless @friend = User.friendly.find(params[:friend_id])
      @friendship = current_user.friendships.new(friend: @friend)
    else
      flash[:error] = "Friend required."
      redirect_to statuses_path
    end
  rescue ActiveRecord::RecordNotFound
    render file: 'public/404', status: :not_found
  end

  def create
    if params[:friendship] && params[:friendship].has_key?(:friend_id)
      @friend = User.friendly.find(params[:friendship][:friend_id])
      @friendship = Friendship.request(current_user, @friend)
      respond_to do |format|
        if @friendship.new_record?
          format.html do
            flash[:error] = "Something went wrong."
            redirect_to friendships_path
          end
          format.json { render json: @friendship.to_json, status: :precondition_failed }
        else
          format.html do
            flash[:success] = "Friend request sent."
            redirect_to friendships_path
          end
          format.json { render json: @friendship.to_json }
        end
      end

    else
      flash[:error] = "Friend required."
      redirect_to statuses_path
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    if @friendship.destroy
      redirect_to friendships_path, success: "You are no longer friends."
    else
      redirect_to friendships_path, error: "Something went wrong. Looks like this friendship will last forever!"
    end
  end

end
