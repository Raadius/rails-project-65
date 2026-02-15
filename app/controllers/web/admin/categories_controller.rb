# frozen_string_literal: true

module Web
  class Admin::CategoriesController < Admin::ApplicationController
    before_action :set_category, only: %i[edit update destroy]
    def index
      @categories = Category.order(:name)
    end

    def new
      @category = Category.new
    end

    def edit
    end
    def create
      @category = Category.new(category_params)

      if @category.save
        redirect_to admin_categories_path, notice: t('notices.admin.category_created')
      else
        render :new, status: :unprocessable_entity, alert: t('notices.admin.category_create_error')
      end
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: t('notices.admin.category_updated')
      else
        render :edit, status: :unprocessable_entity, alert: t('notices.admin.category_update_error')
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: t('notices.admin.category_destroyed')
    rescue ActiveRecord::DeleteRestrictionError
      redirect_to admin_categories_path, alert: t('alerts.admin.category_has_bulletins')
    end

    private

    def set_category
      @category = Category.find(params[:id])
    rescue ActiveRecord::DeleteRestrictionError
      redirect_to admin_categories_path, alert: t('notices.admin.category_not_found')
    end

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
