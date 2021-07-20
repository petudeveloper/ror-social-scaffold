class AddInviterIdToFriendship < ActiveRecord::Migration[5.2]
  def change
    add_column :friendships, :inviter_id, :integer, null: false
  end
end
