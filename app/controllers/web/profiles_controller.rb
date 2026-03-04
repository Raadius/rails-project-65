# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  before_action :authenticate_user!

  def show
    @q = current_user.bulletins.order(created_at: :desc).includes(:category).ransack(params[:q])
    @bulletins = @q.result.page(params[:page])
    @search_presenter = SearchFormPresenters::ProfileSearchPresenter.new
  end
end
