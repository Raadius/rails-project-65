# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include AuthConcern
  include Pundit::Authorization

  helper_method :current_user, :user_signed_in?, :user_admin?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def require_authentication
    user_not_authorized unless user_signed_in?
  end

  def user_not_authorized
    flash[:alert] = t('notices.user.not_authorized')
    redirect_back(fallback_location: root_path)
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    nil
  end

  def user_signed_in?
    current_user.present?
  end

  def user_admin?
    user_signed_in? && current_user.admin?
  end

  def require_authentication!
    redirect_to root_path, alert: t('notices.user.not_authorized') unless user_signed_in?
  end
end
