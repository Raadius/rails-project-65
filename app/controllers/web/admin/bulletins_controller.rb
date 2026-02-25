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

    def publish
      @bulletin = Bulletin.find(params[:id])

      redirect_to admin_bulletins_path,
                  alert: t('alerts.admin.bulletin_publish_error') unless @bulletin.may_publish?

      @bulletin.publish!
      redirect_to admin_bulletins_path, notice: t('notices.admin.bulletin_published')
    end

    def reject
      @bulletin = Bulletin.find(params[:id])

      redirect_to admin_bulletins_path,
                  alert: t('alerts.admin.bulletin_reject_error') unless @bulletin.may_reject?

      @bulletin.reject!
      redirect_to admin_bulletins_path, notice: t('notices.admin.bulletin_rejected')
    end

    def archive
      @bulletin = Bulletin.find(params[:id])

      redirect_to admin_bulletins_path,
                  alert: t('alerts.admin.bulletin_archive_error') unless @bulletin.may_archive?

      @bulletin.archive!
      redirect_to admin_bulletins_path, notice: t('notices.admin.bulletin_archived')
    end
  end
end
