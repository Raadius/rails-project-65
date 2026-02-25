# frozen_string_literal: true

module Web
  class Admin::BulletinsController < Admin::ApplicationController
    before_action :set_bulletin, only: %i[show publish reject archive]

    def index
      @q = Bulletin.includes(:category, :user).recent.ransack(params[:q])
      @bulletins = @q.result.page(params[:page])
      @bulletins = @bulletins.where(state: params[:state]) if params[:state].present?
      @search_presenter = SearchFormPresenters::AdminBulletinsSearchPresenter.new
    end

    def show
      authorize @bulletin
    end

    def publish
      authorize @bulletin
      if @bulletin.publish!
        redirect_to admin_bulletins_path, notice: t('notices.admin.bulletin_published')
      else
        redirect_to admin_bulletins_path, alert: t('alerts.admin.bulletin_publish_error')
      end
    end

    def reject
      authorize @bulletin
      if @bulletin.reject!
        redirect_to admin_bulletins_path, notice: t('notices.admin.bulletin_rejected')
      else
        redirect_to admin_bulletins_path, alert: t('alerts.admin.bulletin_reject_error')
      end
    end

    def archive
      authorize @bulletin
      if @bulletin.archive!
        redirect_to admin_bulletins_path, notice: t('notices.admin.bulletin_archived')
      else
        redirect_to admin_bulletins_path, alert: t('alerts.admin.bulletin_archive_error')
      end
    end

    private

    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
    end
  end
end
