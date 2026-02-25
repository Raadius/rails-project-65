# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :require_authentication, only: %i[new create submit_for_moderation archive restore_from_archive]
  before_action :set_bulletin, only: %i[show edit update submit_for_moderation archive restore_from_archive]

  def index
    @q = Bulletin.published_only.recent.includes(:category, :user).ransack(params[:q])
    @bulletins = @q.result.page(params[:page])
    @categories = Category.all
    @search_presenter = SearchFormPresenters::BulletinsSearchPresenter.new(@categories)
  end

  def show
    unless policy(@bulletin).show?
      redirect_to root_path, alert: t('notices.bulletins.not_found')
    end
  end

  def new
    @bulletin = Bulletin.new
    authorize @bulletin, :new?
  end

  def edit
    authorize @bulletin
  end

  def create
    @bulletin = current_user.bulletins.build(permitted_params)
    authorize @bulletin, :create?

    if @bulletin.save
      redirect_to profile_path, notice: t('notices.bulletins.created')
    else
      render :new, status: :unprocessable_entity, alert: t('notices.bulletins.create_error')
    end
  end

  def update
    authorize @bulletin

    if @bulletin.update(permitted_params)
      redirect_to profile_path, notice: t('notices.bulletins.updated')
    else
      render :edit, status: :unprocessable_entity, alert: t('notices.bulletins.update_error')
    end
  end

  def submit_for_moderation
    authorize @bulletin, :to_moderate?

    if @bulletin.submit_for_moderation!
      redirect_to profile_path, notice: t('notices.bulletins.submitted_for_moderation')
    else
      redirect_to profile_path, alert: t('notices.bulletins.submit_for_moderation_error')
    end
  end

  def archive
    authorize @bulletin

    if @bulletin.archive!
      redirect_to profile_path, notice: t('notices.bulletins.archived')
    else
      redirect_to profile_path, alert: t('notices.bulletins.archive_error')
    end
  end

  def restore_from_archive
    authorize @bulletin

    if @bulletin.restore_from_archive!
      redirect_to profile_path, notice: t('notices.bulletins.restored')
    else
      redirect_to profile_path, alert: t('notices.bulletins.restore_error')
    end
  end

  private

  def permitted_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end
end
