class FriendshipsController < ApplicationController
    def index ; end
    
    
    def create
        user = User.find(params[:invited_user_id])
        friendship = Friendship.create(user_id: current_user.id, friend_id: params[:invited_user_id], confirmed: false)
        if friendship.save
            redirect_to user, notice: 'Your friendship invitation was successfully sent.'
        end
    end

    #Accept friendship
    def update
        inviter_user = User.find(params[:id])
        current_user.confirm_friend inviter_user
        if current_user.friend? inviter_user
            redirect_to inviter_user, notice: 'Your friendship invitation was accepted.'
        end
    end
    

    def destroy
        
    end
    
end