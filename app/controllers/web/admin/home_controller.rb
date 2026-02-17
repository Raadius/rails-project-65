# frozen_string_literal: true

module Web
  class Admin::HomeController < Admin::ApplicationController
    def index
      @bulletins = Bulletin.for_moderation.recent.includes(:category).page(params[:page])
    end
  end
end
