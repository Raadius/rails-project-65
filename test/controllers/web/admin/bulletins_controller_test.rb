# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class BulletinsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin = users(:two)
        @user = users(:one)
        @moderation_bulletin = bulletins(:under_moderation_bulletin)
        @published_bulletin = bulletins(:published_bulletin)
        @draft_bulletin = bulletins(:draft_bulletin)
      end

      test 'should redirect non-admin to root' do
        sign_in(@user)

        get admin_bulletins_url

        assert_redirected_to root_path
        assert_equal I18n.t('notices.user.not_admin'), flash[:alert]
      end

      test 'should allow admin to access bulletins' do
        sign_in(@admin)

        get admin_bulletins_url

        assert_response :success
      end

      test 'should redirect unauthenticated user to auth' do
        get admin_bulletins_url

        assert_redirected_to auth_request_path(:github)
      end

      # Тесты index
      test 'admin should see all bulletins' do
        sign_in(@admin)

        get admin_bulletins_url

        assert_response :success
        assert_select 'table'
      end

      test 'admin should filter bulletins by state via ransack' do
        sign_in(@admin)

        get admin_bulletins_url, params: { q: { state_eq: 'under_moderation' } }

        assert_response :success
      end

      # Тесты publish
      test 'admin should publish bulletin under moderation' do
        sign_in(@admin)

        assert @moderation_bulletin.under_moderation?

        post publish_admin_bulletin_path(@moderation_bulletin)

        assert_redirected_to admin_bulletins_path
        @moderation_bulletin.reload
        assert @moderation_bulletin.published?
      end

      test 'admin cannot publish draft bulletin' do
        sign_in(@admin)

        assert @draft_bulletin.draft?

        assert_raises(AASM::InvalidTransition) do
          post publish_admin_bulletin_path(@draft_bulletin)
        end
      end

      # Тесты reject
      test 'admin should reject bulletin under moderation' do
        sign_in(@admin)

        assert @moderation_bulletin.under_moderation?

        post reject_admin_bulletin_path(@moderation_bulletin)

        assert_redirected_to admin_bulletins_path
        @moderation_bulletin.reload
        assert @moderation_bulletin.rejected?
      end

      # Тесты archive
      test 'admin should archive any bulletin' do
        sign_in(@admin)

        # Archive published
        post archive_admin_bulletin_path(@published_bulletin)
        @published_bulletin.reload
        assert @published_bulletin.archived?

        # Archive draft
        post archive_admin_bulletin_path(@draft_bulletin)
        @draft_bulletin.reload
        assert @draft_bulletin.archived?
      end

      # Тесты show
      test 'admin should view any bulletin' do
        sign_in(@admin)

        get admin_bulletin_url(@draft_bulletin)
        assert_response :success

        get admin_bulletin_url(@moderation_bulletin)
        assert_response :success

        get admin_bulletin_url(@published_bulletin)
        assert_response :success
      end

      test 'admin should search bulletins by title' do
        sign_in(@admin)
        get admin_bulletins_url, params: { q: { title_cont: @moderation_bulletin.title } }

        assert_response :success
        assert_select 'a', text: @moderation_bulletin.title
      end

      test 'admin should show search form' do
        sign_in(@admin)
        get admin_bulletins_url

        assert_select 'form input[name=?]', 'q[title_cont]'
        assert_select 'form select[name=?]', 'q[state_eq]'
      end

      test "should paginate admin bulletins" do
        sign_in(@admin)
        get admin_bulletins_url, params: { page: 1 }
        assert_response :success
      end
    end
  end
end
