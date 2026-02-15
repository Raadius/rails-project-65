# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :require_authentication, only: %i[new create]
  before_action :set_bulletin, only: %i[show edit update]
  before_action :auth_bulletin_owner, only: %i[edit update]

  def index
    @bulletins = Bulletin.published_only.recent.includes(:category, :user)
    @categories = Category.all
  end

  def show
    unless @bulletin.published? || bulletin_accessible_for_current_user
      redirect_to root_path, alert: t('notices.bulletins.not_found')
    end
  end
  def new
    @bulletin = Bulletin.new
  end

  def edit
  end
  def create
    @bulletin = current_user.bulletins.build(permitted_params)

    if @bulletin.save
      redirect_to profile_path, notice: t('notices.bulletins.created')
    else
      render :new, status: :unprocessable_entity, alert: t('notices.bulletins.create_error')
    end
  end


  def update
    if @bulletin.update(permitted_params)
      redirect_to profile_path, notice: t('notices.bulletins.updated')
    else
      render :edit, status: :unprocessable_entity, alert: t('notices.bulletins.update_error')
    end
  end

  private

  def permitted_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end

  def auth_bulletin_owner
    unless @bulletin.user == current_user
      redirect_to root_path, notice: t('notices.user.not_authorized')
    end
  end

  def bulletin_accessible_for_current_user
    return false unless user_signed_in?
    @bulletin.user == current_user || user_admin?
  end
end
