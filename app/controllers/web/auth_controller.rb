# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      auth = request.env['omniauth.auth']

      email = auth.info.email
      name = auth.info.name

      user = User.find_or_initialize_by(email:)
      user.name = name

      if user.save!
        sign_in(user)
        redirect_to root_path, notice: t('notices.user.signed_in')
      else
        redirect_to root_path, alert: t('notices.user.auth_error')
      end
    end

    def failure
      redirect_to root_path, alert: t('notices.user.auth_error')
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: t('notices.user.logged_out')
    end
  end
end
