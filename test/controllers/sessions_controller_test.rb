require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.new(pseudo: 'TestUser', email: 'test@example.com', password: 'password',
                     password_confirmation: 'password')
    puts @user.errors.full_messages unless @user.valid?
    @user.save!
    @user.confirm
  end

  test 'should get new' do
    get new_user_session_url
    assert_response :success
  end

  test 'should set new resource' do
    get new_user_session_url
    assert_not_nil assigns(:resource)
    assert_equal User, assigns(:resource).class
  end

  test 'should allow valid user sign in' do
    post user_session_url, params: { user: { login: @user.email, password: 'password' } }
    assert_redirected_to root_path
    assert_equal 'Connecté.', flash[:notice]
  end

  test 'should not allow invalid user sign in' do
    post user_session_url, params: { user: { login: @user.email, password: 'wrongpassword' } }
    assert_template :new
    assert_not flash[:alert].empty?
  end

  test 'should not allow unconfirmed user sign in' do
    @user.update!(confirmed_at: nil)
    post user_session_url, params: { user: { login: @user.email, password: 'password' } }
    assert_template :new
    assert_equal 'Vous devez valider votre compte pour continuer. Un e-mail de confirmation vous a été envoyé.',
                 flash[:alert]
  end

  test 'authenticate_and_sign_in_user should sign in user' do
    post user_session_url, params: { user: { login: @user.email, password: 'password' } }
    assert_equal 'Connecté.', flash[:notice]
  end

  test 'after_sign_in_path_for should redirect to root path' do
    post user_session_url, params: { user: { login: @user.email, password: 'password' } }
    assert_redirected_to root_path
  end

  test 'after_sign_out_path_for should redirect to root path' do
    delete destroy_user_session_path
    assert_redirected_to root_path
  end

  test 'user_exists_and_unconfirmed? should return true if user is unconfirmed' do
    unconfirmed_user = User.create!(pseudo: 'Unconfirmed', email: 'unconfirmed@example.com', password: 'password',
                                    password_confirmation: 'password')
    post user_session_url, params: { user: { login: unconfirmed_user.email, password: 'password' } }
    assert_equal 'Vous devez valider votre compte pour continuer. Un e-mail de confirmation vous a été envoyé.',
                 flash[:alert]
  end

  test 'user_exists_and_unconfirmed? should return false if user is confirmed' do
    post user_session_url, params: { user: { login: @user.email, password: 'password' } }
    assert_equal 'Connecté.', flash[:notice]
  end

  test 'user_exists_and_unconfirmed? should return false if user does not exist' do
    post user_session_url, params: { user: { login: 'nonexistant@example.com', password: 'password' } }
    assert_equal "Email/Pseudo n'existe pas.", flash[:alert]
  end

  test 'should return turbo_stream when format is turbo_stream' do
    post user_session_url(format: :turbo_stream), params: { user: { login: @user.email, password: 'password' } }
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", @response.content_type
  end
  
  test 'should return turbo_stream when unconfirmed user tries to sign in' do
    @user.update!(confirmed_at: nil)
    post user_session_url(format: :turbo_stream), params: { user: { login: @user.email, password: 'password' } }
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", @response.content_type
  end
  
  test 'should return turbo_stream when non-existent user tries to sign in' do
    post user_session_url(format: :turbo_stream), params: { user: { login: 'nonexistant@example.com', password: 'password' } }
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", @response.content_type
  end
  
end
