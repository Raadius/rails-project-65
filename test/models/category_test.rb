# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'should not save category without name' do
    category = Category.new
    assert_not category.valid?
  end

  test 'should not save category with duplicate name' do
    Category.create!(name: 'Unique')
    duplicate = Category.new(name: 'Unique')
    assert_not duplicate.valid?
  end

  test 'should not save category with short name' do
    category = Category.new(name: 'ab')
    assert_not category.valid?
  end

  test 'should save valid category' do
    category = Category.new(name: 'Valid Name')
    assert category.valid?
  end
end
