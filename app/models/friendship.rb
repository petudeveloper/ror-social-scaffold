class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  belongs_to :inviter, class_name: 'User'

  validates :user_id, uniqueness: { scope: :friend_id, message: 'You have already sent a request to this user' }
  validates :inviter_id, presence: true
end
