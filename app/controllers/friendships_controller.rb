class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friendships = current_user.friendships
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
    @friendship = current_user.friendships.find(params[:id])
    @friend = @friendship.friend
  end

  def new
    if params[:friend_id]
      render file: 'public/404', status: :not_found unless @friend = User.find_by(slug: params[:friend_id])
      @friendship = current_user.friendships.new(friend: @friend)
    else
      flash[:error] = "Friend required."
      redirect_to statuses_path
    end
  end

  def create
    if params[:friendship] && params[:friendship].has_key?(:friend_id)
      @friend = User.find_by(slug: params[:friendship][:friend_id])
      @friendship = Friendship.request(current_user, @friend)
      if @friendship.new_record?
        flash[:error] = "Something went wrong."
      else
        flash[:success] = "Friend request sent."
      end
      redirect_to friendships_path
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
