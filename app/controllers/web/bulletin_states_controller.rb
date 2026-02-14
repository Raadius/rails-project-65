# frozen_string_literal: true

class Web::BulletinStatesController < Web::ApplicationController
  before_action :require_authentication!
  before_action :set_bulletin
  before_action :authorize_bulletin_owner

  def submit_for_moderation
    if @bulletin.submit_for_moderation!
      redirect_to profile_path, notice: t('notices.bulletins.submitted_for_moderation')
    else
      redirect_to profile_path, alert: t('notices.bulletins.submit_for_moderation_error')
    end
  end

  def archive
    if @bulletin.archive!
      redirect_to profile_path, notice: t('notices.bulletins.archived')
    else
      redirect_to profile_path, alert: t('notices.bulletins.archive_error')
    end
  end

  def restore_from_archive
    if @bulletin.restore_from_archive!
      redirect_to profile_path, notice: t('notices.bulletins.restored')
    else
      redirect_to profile_path, alert: t('notices.bulletins.restore_error')
    end
  end

  private

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end

  def authorize_bulletin_owner
    unless @bulletin.user == current_user
      redirect_to root_path, alert: t('notices.user.not_authorized')
    end
  end
end
