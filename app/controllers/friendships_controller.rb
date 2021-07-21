class FriendshipsController < ApplicationController
  def index; end

  def create
    user = User.find(params[:invited_user_id])
    friendship = Friendship.create(user_id: current_user.id, friend_id: params[:invited_user_id], confirmed: false)
    redirect_to user, notice: 'Your friendship invitation was successfully sent.' if friendship.save
  end

  # Accept friendship
  def update
    inviter_user = User.find(params[:id])
    Friendship.create!(friend_id: inviter_user.id, user_id: current_user.id, confirmed: true)
    return unless current_user.friends.include? inviter_user

    redirect_to inviter_user, notice: 'Your friendship invitation was accepted.'
  end

  def destroy
    inviter_user = User.find(params[:id])
    current_user.reject_friendship inviter_user
    redirect_to current_user, notice: 'Invitation successfully rejected.'
  end
end
