# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class HomeControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin = users(:two)
        @user = users(:one)
      end

      test 'should redirect to non-admin root' do
        sign_in(@user)
        get admin_root_path
        assert_redirected_to root_path
      end

      test 'should redirect unauthenticated user' do
        get admin_root_url
        assert_redirected_to auth_request_path(:github)
      end

      test 'admin should see moderation page' do
        sign_in(@admin)
        get admin_root_url
        assert_response :success
      end

      test 'admin should see only under_moderation bulletins' do
        sign_in(@admin)
        get admin_root_url

        assert_response :success

        assert_select 'a[href=?]', admin_bulletin_path(bulletins(:under_moderation_bulletin))
        assert_select 'a[href=?]', admin_bulletin_path(bulletins(:draft_bulletin)), count: 0
        assert_select 'a[href=?]', admin_bulletin_path(bulletins(:published_bulletin)), count: 0
        assert_select 'a[href=?]', admin_bulletin_path(bulletins(:archived_bulletin)), count: 0
      end
    end
  end
end
