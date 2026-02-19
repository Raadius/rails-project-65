# frozen_string_literal: true

class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_user, :user_signed_in?, :user_admin?

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
    unless user_signed_in?
      redirect_to root_path, alert: 'Please sign in to continue'
    end
  end
end
