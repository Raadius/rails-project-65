# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  allow_browser versions: :modern

  include Pundit::Authorization
  include Authentication

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized!
end
