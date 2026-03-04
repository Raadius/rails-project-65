# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :signed_in?
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end

  def signed_in?
    current_user.present?
  end

  def authenticate_user!
    redirect_to root_path, alert: t('notices.user.not_authorized') unless signed_in?
  end

  def user_not_authorized!
    flash[:alert] = t('notices.user.not_authorized')
    redirect_back_or_to(root_path)
  end
end
