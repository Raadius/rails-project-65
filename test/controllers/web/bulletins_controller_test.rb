# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @second_user = users(:three)

    @bulletin = bulletins(:draft_bulletin)
    @published_bulletin = bulletins(:published_bulletin)

    @category = categories(:one)
  end

  test 'should get index' do
    get bulletins_url
    assert_response :success
  end

  test 'should get show' do
    get bulletin_path(@published_bulletin)
    assert_response :success
  end

  test 'should get edit' do
    sign_in(@user)
    get bulletin_path(@bulletin)
    assert_response :success
  end

  test 'should get new' do
    sign_in(@user)

    get new_bulletin_path
    assert_response :success
  end

  test 'should create bulletin' do
    upload_file_name = 'fixtures_image.jpg'

    attrs = {
      title: Faker::Science.element,
      description: Faker::Lorem.sentence(word_count: 10),
      image: fixture_file_upload(upload_file_name, 'image/jpg'),
      category_id: @category.id
    }

    sign_in(@user)

    assert_difference('Bulletin.count') do
      post bulletins_url, params: { bulletin: attrs }
    end

    created_bulletin = Bulletin.find_by(attrs.except(:image))

    assert created_bulletin
    assert created_bulletin.image.filename, upload_file_name
    assert_redirected_to bulletin_path(created_bulletin)
  end

  test 'should not create bulletin if user is not logged in' do
    upload_file_name = 'fixtures_image.jpg'

    attrs = {
      title: Faker::Science.element,
      description: Faker::Lorem.sentence(word_count: 10),
      image: fixture_file_upload(upload_file_name, 'image/jpg'),
      category_id: @category.id
    }

    post bulletins_url, params: { bulletin: attrs }
    assert_response :found
  end

  test 'should not show not published bulletin' do
    get bulletin_path(@bulletin)
    assert_response :redirect
  end

  test 'should update bulletin' do
    sign_in(@user)

    upload_file_name = 'fixtures_image.jpg'

    attrs = {
      title: Faker::Science.element,
      description: Faker::Lorem.sentence(word_count: 10),
      image: fixture_file_upload(upload_file_name, 'image/jpg'),
      category_id: @category.id
    }

    put bulletin_path(@bulletin), params: { bulletin: attrs }

    updated_bulletin = Bulletin.find_by(attrs.except(:image))

    assert @bulletin.id, updated_bulletin.id
    assert_redirected_to bulletin_path(@bulletin)
  end

  test 'should not update bulletin for a different user' do
    sign_in(@second_user)

    upload_file_name = 'fixtures_image.jpg'

    attrs = {
      title: Faker::Science.element,
      description: Faker::Lorem.sentence(word_count: 10),
      image: fixture_file_upload(upload_file_name, 'image/jpg'),
      category_id: @category.id
    }

    put bulletin_path(@bulletin), params: { bulletin: attrs }

    updated_bulletin = Bulletin.find_by(attrs.except(:image))

    assert_nil updated_bulletin
    assert_redirected_to root_path
  end

  test 'should archive bulletin' do
    sign_in(@user)
    patch archive_bulletin_path(@bulletin)
    @bulletin.reload
    assert @bulletin.archived?
  end

  test 'should send bulletin to moderation' do
    sign_in(@user)
    patch to_moderate_bulletin_path(@bulletin)
    @bulletin.reload
    assert @bulletin.under_moderation?
  end
end
