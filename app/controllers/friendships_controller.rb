class FriendshipsController < ApplicationController
    def create
        current_user.friendships.create(friend_id: params[:invited_user_id], confirmed: false)
    end

    #Accept friendship
    def update
        
    end
    

    def destroy
        
    end
    
end