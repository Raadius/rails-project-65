# frozen_string_literal: true

require 'test_helper'

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:two)
    @user = users(:one)
    @category = categories(:one)
    @multiple_bulletins_category = categories(:two)
    @empty_category = categories(:empty_category)

    sign_in(@admin)
  end

  test 'should get index' do
    get admin_categories_path
    assert_response :success
  end

  test 'should get new' do
    get new_admin_category_path
    assert_response :success
  end

  test 'should create category' do
    attrs = {
      name: Faker::Science.element
    }

    assert_difference('Category.count') do
      post admin_categories_url, params: { category: attrs }
    end

    created_category = Category.find_by(attrs)

    assert created_category
    assert_redirected_to admin_categories_path
  end

  test 'should not create category if user is not an admin' do
    sign_in(@user)

    attrs = {
      name: Faker::Science.element
    }

    post admin_categories_url, params: { category: attrs }

    assert_redirected_to root_path
  end

  test 'should update' do
    attrs = {
      name: Faker::Science.element
    }

    patch admin_category_path(@category), params: { category: attrs }

    updated_category = Category.find_by(attrs)

    assert updated_category
    assert_redirected_to admin_categories_path
  end

  test 'should not delete category with linked bulletins' do
    delete admin_category_path(@multiple_bulletins_category)

    deleted_category = Category.find_by(id: @multiple_bulletins_category.id)

    assert_not_nil deleted_category
  end

  test 'should delete empty category' do
    assert_difference('Category.count', -1) do
      delete admin_category_path(@empty_category)
    end

    assert_response :redirect
  end
end
