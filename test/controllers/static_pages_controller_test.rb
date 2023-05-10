# frozen_string_literal: true

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_url
    assert_response :success
    assert_select 'title', 'Home | RepairMagic'
  end

  test 'should get about' do
    get about_url
    assert_response :success
    assert_select 'title', 'About | RepairMagic'
  end

  test 'should get contact' do
    get contact_url
    assert_response :success
    assert_select 'title', 'Contact | RepairMagic'
  end

  test 'should redirect to home and show alert when not logged in and accessing services' do
    get services_url
    assert_redirected_to root_url
    follow_redirect!
    assert_not flash[:alert].empty?
    assert_equal 'Vous devez être connecté pour accéder à cette page', flash[:alert]
  end

  test 'should get services when logged in and confirmed' do
    user = User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password')
    user.confirm
    sign_in user
    get services_url
    assert_response :success
    assert_select 'title', 'Services | RepairMagic'
  end
end
