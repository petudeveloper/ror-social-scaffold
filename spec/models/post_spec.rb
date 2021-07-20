require 'rails_helper'

RSpec.describe Post, type: :model do
  before(:each) do
    User.create(name: 'User1', email: 'user1@example.com',
                password: '123456', password_confirmation: '123456')
  end

  describe 'Post validations' do
    it 'post cannot be empty' do
      user = User.find_by(name: 'User1')
      post = user.posts.build
      expect(post.valid?).to be(false)
    end
  end

  describe 'Post associations' do
    it 'deletes dependent objects' do
      user = User.find_by(name: 'User1')
      expect(user.class).to be(User)
      post = user.posts.create(content: 'A simple post')
      user.liked_posts << post
      expect(post.likes.count).to eq(1)
    end
  end
end
