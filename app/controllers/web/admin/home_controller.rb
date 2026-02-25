# frozen_string_literal: true

module Web
  class Admin::HomeController < Admin::ApplicationController
    def index
      @bulletins = Bulletin.under_moderation.order(created_at: :desc).includes(:category).page(params[:page])
    end
  end
end
