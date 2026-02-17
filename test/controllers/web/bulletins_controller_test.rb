# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @published_bulletin = bulletins(:published_bulletin)
      @draft_bulletin = bulletins(:draft_bulletin)
      @user = users(:one)
      @owner = users(:two)
      @non_owner = users(:three)
    end

    # Тесты index
    test 'should show only published bulletins on index' do
      get bulletins_url

      assert_response :success

      # Проверяем, что показываются только опубликованные
      assert_select 'a[href=?]', bulletin_path(@published_bulletin)
    end

    test 'should not show draft bulletins on index' do
      get bulletins_url

      assert_response :success

      # Черновики не должны отображаться
      assert_select 'a[href=?]', bulletin_path(@draft_bulletin), count: 0
    end

    # Тесты show
    test 'anyone can view published bulletin' do
      get bulletin_url(@published_bulletin)

      assert_response :success
    end

    test 'owner can view draft bulletin' do
      sign_in(@user)

      get bulletin_url(@draft_bulletin)

      assert_response :success
    end

    test 'non-owner cannot view draft bulletin' do
      sign_in(@non_owner)

      get bulletin_url(@draft_bulletin)

      assert_redirected_to root_path
      assert_equal I18n.t('notices.bulletins.not_found'), flash[:alert]
    end

    test 'admin can view any bulletin' do
      admin = users(:two)
      sign_in(admin)

      get bulletin_url(@draft_bulletin)

      assert_response :success
    end

    test 'should create bulletin in draft state' do
      sign_in(@user)

      assert_difference('Bulletin.count') do
        post bulletins_url, params: {
          bulletin: {
            title: 'New Test Bulletin',
            description: 'Test Description for new bulletin',
            category_id: categories(:one).id,
            image: fixture_file_upload('fixtures_image.jpg', 'image/jpeg')
          }
        }
      end

      bulletin = Bulletin.last
      assert bulletin.draft?
      assert_redirected_to profile_path
    end

    test 'should filter bulletins by title' do
      get root_url, params: { q: { title_cont: @published_bulletin.title } }

      assert_response :success
      assert_select 'a', text: @published_bulletin.title
    end

    test 'should filter bulletins by category' do
      get root_url, params: { q: { category_id_eq: @published_bulletin.category_id } }
      assert_response :success
    end

    test 'should return no results for non-matching search' do
      get root_url, params: { q: { title_cont: 'несуществующее_объявление_xyz' } }
      assert_response :success
      assert_select '.card', count: 0
    end

    test 'should show search form on index' do
      get root_url
      assert_response :success
      assert_select 'form input[name=?]', 'q[title_cont]'
      assert_select 'form select[name=?]', 'q[category_id_eq]'
    end

    test 'should paginate bulletins on index' do
      get bulletins_url, params: { page: 1 }
      assert_response :success
    end
  end
end
