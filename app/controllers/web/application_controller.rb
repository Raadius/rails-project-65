# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include AuthConcern

  private
  
  def require_authentication
    user_not_authorized unless signed_in?
  end

  def user_not_authorized
    flash[:alert] = t('alerts.not_authorized')
    redirect_back(fallback_location: root_path)
  end
end
