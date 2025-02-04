require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Test validations' do
    it 'user id invalid when there is no password' do
      user = User.new(name: 'user', email: 'user@example.com')
      expect(user.valid?).to be(false)
    end
  end

  def create_invitation_pair(inviter, invitee, confirmed)
    Friendship.create(
      user_id: inviter.id,
      friend_id: invitee.id,
      confirmed: confirmed
    )
    Friendship.create(
      user_id: invitee.id,
      friend_id: inviter.id,
      confirmed: confirmed
    )
  end

  describe 'Test associations' do
    before(:each) do
      users = []
      5.times do |n|
        user = User.create(name: "User#{n}",
                           email: "user#{n}@example.com",
                           password: '123456',
                           password_confirmation: '123456')
        users[n] = user
      end
      (1..4).each do |n|
        create_invitation_pair(users[0], users[n], n.even?)
      end
    end

    it 'user is associated to their sent invitations' do
      user = User.find_by(name: 'User0')
      expect(user.friendships.count).to eq(4)
    end

    it 'user is associated to their received invitations' do
      user = User.find_by(name: 'User1')
      expect(user.friend_requests.count).to eq(1)
    end

    it 'user is associated to their invited friends' do
      user = User.find_by(name: 'User0')
      expect(user.pending_friends.count).to eq(2)
    end
  end
end
