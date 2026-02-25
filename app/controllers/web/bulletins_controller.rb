# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :user_signed_in?, except: %i[index show]

  def index
    @q = Bulletin.published.order(created_at: :desc).includes(:category, :user).ransack(params[:q])
    @bulletins = @q.result.page(params[:page])
    @categories = Category.all
    @search_presenter = SearchFormPresenters::BulletinsSearchPresenter.new(@categories)
  end

  def show
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin
  end

  def new
    @bulletin = Bulletin.new
  end

  def edit
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin
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
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin

    if @bulletin.update(permitted_params)
      redirect_to profile_path, notice: t('notices.bulletins.updated')
    else
      render :edit, status: :unprocessable_entity, alert: t('notices.bulletins.update_error')
    end
  end

  def submit_for_moderation
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin, :to_moderate?

    return redirect_back fallback_location: root_path,
                         notice:
                           t('notices.bulletins.submit_for_moderation_error') unless @bulletin.may_submit_for_moderation?

    @bulletin.submit_for_moderation!
    redirect_to profile_path, notice: t('notices.bulletins.submitted_for_moderation')
  end

  def archive
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin

    return redirect_back fallback_location: root_path,
                         notice: t('notices.bulletins.archive_error') unless @bulletin.may_archive?

    @bulletin.archive!
    redirect_to profile_path, notice: t('notices.bulletins.archived')
  end

  def restore_from_archive
    @bulletin = Bulletin.find(params[:id])
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
end
