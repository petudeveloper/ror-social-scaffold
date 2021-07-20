require 'rails_helper'

RSpec.describe 'Feature test' do
  # Populate the database
  before :each do
    users = []
    4.times do |n|
      user = User.create(name: "User#{n + 1}",
                         email: "user#{n + 1}@example.com",
                         password: '123456',
                         password_confirmation: '123456')
      users[n] = user
    end
    users[0].posts.create(content: 'Hello world')
    users[0].friendships.create(friend_id: users[3].id,
                                confirmed: true)
    users[0].friendships.create(friend_id: users[2].id,
                                confirmed: false)
  end

  def login_process(user_number: 1)
    visit 'users/sign_in'
    within('#new_user') do
      fill_in 'Email', with: "user#{user_number}@example.com"
      fill_in 'Password', with: '123456'
    end
    click_button 'Log in'
  end

  describe 'Sign up process', type: :feature do
    it ' Signs up a user' do
      visit 'users/sign_up'
      within('#new_user') do
        fill_in 'Name', with: 'mike'
        fill_in 'Email', with: 'mike@example.com'
        fill_in 'Password', with: '123456'
        fill_in 'Password confirmation', with: '123456'
      end
      click_button 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    it 'Fails to sign up with empty form' do
      visit 'users/sign_up'

      click_button 'Sign up'
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end
  end

  describe 'log in process', type: :feature do
    it 'logs in' do
      login_process
      expect(page).to have_content 'Signed in successfully.'
    end

    it 'fails to log in with empty fields' do
      visit 'users/sign_in'
      within('#new_user') do
        fill_in 'Email', with: ''
        fill_in 'Password', with: '123456'
      end
      click_button 'Log in'
      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  describe 'log out process', type: :feature do
    it 'successfully logs out' do
      login_process
      click_link 'Sign out'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'save post', type: :feature do
    it 'creates a post' do
      visit 'users/sign_in'
      within('#new_user') do
        fill_in 'Email', with: 'user1@email.com'
        fill_in 'Password', with: '123456'
      end
      click_button 'Log in'
      within('#new_post') do
        fill_in 'post_content', with: 'hello world'
        click_button 'Save'
      end
      expect(page).to have_content 'Post was successfully created'
    end

    it 'creates a post' do
      login_process
      within('#new_post') do
        fill_in 'post_content', with: ''
        click_button 'Save'
      end
      expect(page).to have_content "Post could not be saved. Content can't be blank"
    end
  end

  describe 'Friendships', type: :feature do
    it 'sends an invitation to an unrelated user' do
      login_process
      visit '/users'
      click_button('INVITE TO FREINDSHIP')
      expect(page).to have_content 'Your friendship invitation was successfully sent.'
    end

    it 'can confirm received invitation' do
      login_process(user_number: 3)
      visit '/users'
      click_link 'User3'
      click_button 'ACCEPT FRIENDSHIP'
      expect(page).to have_content 'Your friendship invitation was accepted.'
    end

    it 'can reject received invitation' do
      login_process(user_number: 3)
      visit '/users'
      click_link 'User3'
      click_link 'REJECT FRIENDSHIP'
      expect(page).to have_content 'Invitation successfully rejected.'
    end
  end
end
