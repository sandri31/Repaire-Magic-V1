# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_url
    assert_response :success
  end

  test 'should render index view' do
    get root_url
    assert_template :index
  end

  test 'should set devise resource variables' do
    get root_url
    assert assigns(:resource)
    assert assigns(:resource_name)
    assert assigns(:devise_mapping)
  end
end
