# frozen_string_literal: true

module Web
  class Admin::ApplicationController < Web::ApplicationController
    before_action :require_authentication!
  end

  private

  def require_admin
    unless user_admin?
      redirect_to root_path, alert: t('notices.user.not_admin')
    end
  end
end
