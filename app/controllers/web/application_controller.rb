# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include AuthConcern

  private

  def user_not_authorized
    flash[:alert] = 'User is not authorized!'
    redirect_back(fallback_location: root_path)
  end
end
