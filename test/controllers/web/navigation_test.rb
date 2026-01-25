# frozen_string_literal: true

require 'test_helper'

module Web
  class NavigationTest < ActionDispatch::IntegrationTest
    test 'admin link is hidden for not admin' do
      user = users(:one)
      sign_in(user)

      get root_path
      assert_response :success
      assert_no_match 'admin', response.body.downcase
    end

    test 'admin link is shown to admin' do
      user = users(:two)
      sign_in(user)

      get root_path
      assert_response :success
      assert_match 'admin', response.body.downcase
    end
  end
end
