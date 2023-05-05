# frozen_string_literal: true

require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'should allow valid sign up parameters' do
    post user_registration_url,
         params: { user: { pseudo: 'TestUser', email: 'test@example.com', password: 'password',
                           password_confirmation: 'password' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_not flash[:notice].empty?
  end

  test 'should allow valid sign in parameters' do
    user = User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password')
    user.confirm
    post user_session_url, params: { user: { login: user.email, password: 'password' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_not flash[:notice].empty?
  end

  test 'should allow valid account update parameters' do
    user = User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password')
    user.confirm
    sign_in user
    put user_registration_url,
        params: { user: { pseudo: 'UpdatedUser', email: 'updated@example.com', password: '', password_confirmation: '',
                          current_password: 'password' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_not flash[:notice].empty?
  end

  test 'should set devise variables' do
    get new_user_session_url
    assert assigns(:resource)
    assert assigns(:resource_name)
  end
end
