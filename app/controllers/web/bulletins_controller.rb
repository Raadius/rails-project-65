# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :require_authentication, only: %i[new create]

  def index
    @bulletins = Bulletin.all
    @categories = Category.all
  end

  def show
    @bulletin = find_bulletin
  end
  def new
    @bulletin = Bulletin.new
  end

  def create
    @bulletin = current_user.bulletins.build(permitted_params)

    if @bulletin.save
      redirect_to bulletin_path(@bulletin), notice: t('notices.bulletins.created')
    else
      render :new, status: :unprocessable_entity, alert: t('notices.bulletins.create_error')
    end
  end

  private

  def permitted_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end

  def find_bulletin
    Bulletin.find(params[:id])
  end
end
