# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin = users(:two)
        @user = users(:one)
        @category = categories(:one)
      end

      test 'should redirect non-admin to root' do
        sign_in(@user)
        get admin_categories_url
        assert_redirected_to root_path
      end

      test 'should redirect unauthenticated user' do
        get admin_categories_url
        assert_redirected_to root_path
      end

      test 'admin should see categories list' do
        sign_in(@admin)
        get admin_categories_url

        assert_response :success

        assert_select 'table' do
          assert_select 'td', text: categories(:one).name
          assert_select 'td', text: categories(:two).name
        end
      end

      test 'admin should see new category form' do
        sign_in(@admin)

        assert_difference('Category.count', 1) do
          post admin_categories_url,
               params: { category: { name: 'New Category' } }
        end

        assert_redirected_to admin_categories_path
        follow_redirect!

        assert_select 'td', text: 'New Category'
      end

      test 'admin should not create category with invalid data' do
        sign_in(@admin)
        assert_difference('Category.count', 0) do
          post admin_categories_url,
               params: { category: { name: 'a' } }
        end

        assert_response :unprocessable_entity
        assert_select 'div.invalid-feedback'
      end

      test 'admin should see edit category form' do
        sign_in(@admin)
        get edit_admin_category_url(@category)
        assert_response :success
      end

      test 'admin should update category' do
        sign_in(@admin)
        patch admin_category_url(@category),
              params: { category: { name: 'Updated Name' } }

        assert_redirected_to admin_categories_path
        @category.reload

        assert_equal 'Updated Name', @category.name
      end

      test 'admin should not update category with invalid data' do
        sign_in(@admin)
        patch admin_category_url(@category),
              params: { category: { name: '' } }

        assert_response :unprocessable_entity
        assert_select 'div.invalid-feedback'
      end

      test 'admin should destroy category without bulletins' do
        sign_in(@admin)
        category = Category.create!(name: 'Empty Category')
        assert_difference('Category.count', -1) do
          delete admin_category_url(category)
        end

        assert_redirected_to admin_categories_path
        follow_redirect!

        assert_select 'td', text: 'Empty Category', count: 0
      end

      test 'admin should not destroy category with bulletins' do
        sign_in(@admin)
        assert_no_difference('Category.count') do
          delete admin_category_url(@category)
        end

        assert_redirected_to admin_categories_path

        assert_equal I18n.t('alerts.admin.category_has_bulletins'), flash[:alert]
      end

      test 'should paginate categories' do
        sign_in(@admin)
        get admin_categories_url, params: { page: 1 }
        assert_response :success
      end
    end
  end
end
