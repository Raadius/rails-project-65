# frozen_string_literal: true

module Web
  class Admin::BulletinsController < Admin::ApplicationController
    before_action :set_bulletin, only: %i[show publish reject archive]
    before_action :require_admin!

    def index
      @bulletins = Bulletin.includes(:category, :user).recent
      @bulletins = @bulletins.where(state: params[:state]) if params[:state].present?
    end

    def show
    end

    def publish
      if @bulletin.publish!
        redirect_to admin_bulletins_path, notice: t('notices.admin.bulletin_published')
      else
        redirect_to admin_bulletins_path, alert: t('alerts.admin.bulletin_publish_error')
      end
    end

    def reject
      if @bulletin.reject!
        redirect_to admin_bulletins_path, notice: t('notices.admin.bulletin_rejected')
      else
        redirect_to admin_bulletins_path, alert: t('alerts.admin.bulletin_reject_error')
      end
    end

    def archive
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

    def require_admin!
      unless user_admin?
        redirect_to root_path, alert: t('notices.user.not_admin')
      end
    end
  end
end
