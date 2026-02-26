# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:two)
    @user = users(:one)

    @bulletin = bulletins(:under_moderation_bulletin)

    sign_in(@admin)
  end

  test 'should get index' do
    get admin_bulletins_url
    assert_response :success
  end

  test 'should delete bulletin' do
    assert_difference('Bulletin.count', -1) do
      delete admin_bulletin_path(@bulletin)
    end

    assert_response :redirect
  end

  test 'should get on moderation bulletins' do
    get admin_root_url
    assert_response :success
  end

  test 'should redirect to root if user is not an admin' do
    sign_in(@user)

    get admin_bulletins_url
    assert_redirected_to root_path
  end

  test 'should publish bulletin' do
    patch publish_admin_bulletin_path(@bulletin)
    @bulletin.reload

    assert @bulletin.state, :published
    assert_response :redirect
  end

  test 'should reject bulletin' do
    patch archive_admin_bulletin_path(@bulletin)
    @bulletin.reload

    assert @bulletin.state, :rejected
  end

  test 'should archive bulletin' do
    patch reject_admin_bulletin_path(@bulletin)
    @bulletin.reload

    assert @bulletin.state, :archived
  end
end
