# frozen_string_literal: true

require 'test_helper'

module Web
  class ProfileControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
    end

    test 'should redirect to sign in when not authenticated' do
      get profile_path
      assert_redirected_to auth_request_path(:github)
    end

    test 'should show profile page when user is signed in' do
      sign_in(@user)
      get profile_path
      assert_response :success
    end

    test 'should show only users bulletin in profile page' do
      sign_in(@user)

      get profile_url

      assert_response :success
      assert_select 'table'
    end

    test 'should show submit for moderation button for draft bulletins' do
      sign_in(@user)

      get profile_url

      assert_response :success
      assert_select 'form[action=?]', submit_for_moderation_bulletin_path(bulletins(:draft_bulletin))
    end

    test 'should show archive button for non-archived bulletins' do
      sign_in(@user)

      get profile_url

      assert_response :success
      assert_select 'form[action=?]', archive_bulletin_path(bulletins(:draft_bulletin))
    end
  end
end
