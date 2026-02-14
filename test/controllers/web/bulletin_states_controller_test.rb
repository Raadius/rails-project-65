# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinStatesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other_user = users(:two)
      @draft_bulletin = bulletins(:draft_bulletin)
      @rejected_bulletin = bulletins(:rejected_bulletin)
      @archived_bulletin = bulletins(:archived_bulletin)
    end

    test 'should submit draft bulletin for moderation' do
      sign_in(@user)

      assert @draft_bulletin.draft?

      post submit_for_moderation_bulletin_path(@draft_bulletin)

      assert_redirected_to profile_path
      @draft_bulletin.reload
      assert @draft_bulletin.under_moderation?
    end

    test 'you should not allow non-owner to submit bulletin for moderation' do
      sign_in(@other_user)

      post submit_for_moderation_bulletin_path(@draft_bulletin)

      assert_redirected_to root_path
      assert_equal I18n.t('notices.user.not_authorized'), flash[:alert]
    end

    test 'should redirect to auth if not signed in' do
      post submit_for_moderation_bulletin_path(@draft_bulletin)

      assert_redirected_to auth_request_path(:github)
    end

    test 'should archive bulletin' do
      sign_in(@user)

      assert_not @draft_bulletin.archived?

      post archive_bulletin_path(@draft_bulletin)

      assert_redirected_to profile_path
      @draft_bulletin.reload
      assert @draft_bulletin.archived?
    end

    test 'should not allow non-owner to archive bulletin' do
      sign_in(@other_user)

      post archive_bulletin_path(@draft_bulletin)

      assert_redirected_to root_path
      @draft_bulletin.reload
      assert_not @draft_bulletin.archived?
    end

    test 'should restore bulletin from archive' do
      sign_in(@user) # archived_bulletin принадлежит user two

      assert @archived_bulletin.archived?

      post restore_from_archive_bulletin_path(@archived_bulletin)

      assert_redirected_to profile_path

      @archived_bulletin.reload
      assert @archived_bulletin.draft?
    end

    test 'should submit rejected bulletin for moderation again' do
      sign_in(@other_user)

      assert @rejected_bulletin.rejected?

      post submit_for_moderation_bulletin_path(@rejected_bulletin)

      assert_redirected_to profile_path
      @rejected_bulletin.reload
      assert @rejected_bulletin.under_moderation?
    end
  end
end
