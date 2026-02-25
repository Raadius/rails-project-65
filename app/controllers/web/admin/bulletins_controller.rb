# frozen_string_literal: true

module Web
  class Admin::BulletinsController < Admin::ApplicationController
    def index
      @q = Bulletin.order(created_at: :desc).includes(:category, :user).ransack(params[:q])
      @bulletins = @q.result.page(params[:page])
      @bulletins = @bulletins.where(state: params[:state]) if params[:state].present?
      @search_presenter = SearchFormPresenters::AdminBulletinsSearchPresenter.new
    end

    def show
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
    end

    def destroy
      @bulletin = Bulletin.find(params[:id])
      @bulletin.destroy
      redirect_to admin_root_path, notice: t('notices.admin.bulletin_destroyed')
    end

    def publish
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin

      if @bulletin.publish!
        redirect_to admin_root_path, notice: t('notices.admin.bulletin_published')
      else
        redirect_to admin_root_path, alert: t('alerts.admin.bulletin_publish_error')
      end
    end

    def reject
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin

      if @bulletin.reject!
        redirect_to admin_root_path, notice: t('notices.admin.bulletin_rejected')
      else
        redirect_to admin_root_path, alert: t('alerts.admin.bulletin_reject_error')
      end
    end

    def archive
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin

      if @bulletin.archive!
        redirect_to admin_root_path, notice: t('notices.admin.bulletin_archived')
      else
        redirect_to admin_root_path, alert: t('alerts.admin.bulletin_archive_error')
      end
    end
  end
end
