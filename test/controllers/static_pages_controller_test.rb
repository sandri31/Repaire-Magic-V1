require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_url
    assert_response :success
    assert_select 'title', 'Home | AuthentificationWithDevise'
  end

  test 'should get about' do
    get about_url
    assert_response :success
    assert_select 'title', 'About | AuthentificationWithDevise'
  end

  test 'should get contact' do
    get contact_url
    assert_response :success
    assert_select 'title', 'Contact | AuthentificationWithDevise'
  end
end
