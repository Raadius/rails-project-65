# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  before_action :require_authentication!

  def show
    @q = current_user.bulletins.recent.includes(:category).ransack(params[:q])
    @bulletins = @q.result
  end
end
