# frozen_string_literal: true

module Web
  class Admin::ApplicationController < Web::ApplicationController
    before_action :authorize_admin

    private

    def authorize_admin
      authorize :user, :admin?
    end
  end
end
