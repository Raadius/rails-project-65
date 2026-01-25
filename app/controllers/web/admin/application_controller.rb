# frozen_string_literal: true

module Web
  class Admin::ApplicationController < Web::ApplicationController
    before_action :require_authentication!
  end
end
