class FriendshipsController < ApplicationController
  before_action :authenticate_user!

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
      @friendship = current_user.friendships.create(friend: @friend)
      flash[:success] = "You are now friends with #{@friend.name}"
      redirect_to profiles_path(@friend)
    else
      flash[:error] = "Friend required."
      redirect_to statuses_path
    end
  end

end
