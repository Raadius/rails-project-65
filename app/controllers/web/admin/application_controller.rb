# frozen_string_literal: true

module Web
  class Admin::ApplicationController < Web::ApplicationController
    before_action :authorize_admin!

    private

    def authorize_admin!
      redirect_to root_path, alert: t('notices.user.not_admin') unless current_user&.admin?
    end
  end
end
