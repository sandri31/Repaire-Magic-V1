# frozen_string_literal: true

require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password')
    @user.confirm
    sign_in @user
  end

  test 'should allow valid user creation' do
    assert_difference('User.count') do
      post user_registration_url,
           params: { user: { pseudo: 'TestUser2', email: 'test2@example.com', password: 'password',
                             password_confirmation: 'password' } }
    end
    assert_redirected_to after_sign_up_path_for(User.last)
    assert_equal 'Vous êtes inscrit avec succès.', flash[:notice]
  end

  test 'should not allow user creation with already taken email' do
    assert_no_difference('User.count') do
      post user_registration_url,
           params: { user: { pseudo: 'TestUser', email: 'test@example.com', password: 'password',
                             password_confirmation: 'password' } }
    end
    assert_template :new
    assert_not flash[:alert].empty?
  end

  test 'should not allow user creation with short password' do
    assert_no_difference('User.count') do
      post user_registration_url,
           params: { user: { pseudo: 'TestUser', email: 'test3@example.com', password: 'short',
                             password_confirmation: 'short' } }
    end
    assert_template :new
    assert_not flash[:alert].empty?
  end

  test 'should update user with valid parameters' do
    put user_registration_url, params: {
      user: {
        email: 'updated@example.com',
        current_password: 'password',
        password: 'newpassword',
        password_confirmation: 'newpassword'
      }
    }
    assert_redirected_to after_update_path_for(@user)
    @user.reload
    assert_equal 'updated@example.com', @user.email
    assert_not flash[:notice].empty?
  end

  test 'should not update user with invalid parameters' do
    put user_registration_url, params: {
      user: {
        email: '',
        current_password: 'password',
        password: 'newpassword',
        password_confirmation: 'newpassword'
      }
    }
    assert_response :success
    @user.reload
    assert_not_equal '', @user.email
    assert_not flash[:alert].empty?
  end

  test 'should not update user with wrong current password' do
    put user_registration_url, params: {
      user: {
        email: 'updated2@example.com',
        current_password: 'wrongpassword',
        password: 'newpassword',
        password_confirmation: 'newpassword'
      }
    }
    assert_response :success
    @user.reload
    assert_not_equal 'updated2@example.com', @user.email
    assert_not flash[:alert].empty?
  end

  test 'should update user with valid parameters and OAuth provider' do
    @user.update!(provider: 'google_oauth2')
    put user_registration_url, params: {
      user: {
        email: 'updated3@example.com',
        password: 'newpassword',
        password_confirmation: 'newpassword'
      }
    }
    assert_redirected_to after_update_path_for(@user)
    @user.reload
    assert_equal 'updated3@example.com', @user.email
    assert_not flash[:notice].empty?
  end

  test 'should not update user with taken email and OAuth
  provider' do
    User.create!(email: 'taken@example.com', password: 'password', password_confirmation: 'password')
    @user.update!(provider: 'google_oauth2')
    put user_registration_url, params: {
      user: {
        email: 'taken@example.com',
        password: 'newpassword',
        password_confirmation: 'newpassword'
      }
    }
    assert_response :success
    @user.reload
    assert_not_equal 'taken@example.com', @user.email
    assert_not flash[:alert].empty?
  end
end
