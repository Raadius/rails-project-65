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
        redirect_to root_path, notice: 'Logged in successfully'
      else
        redirect_to root_path, alert: 'Some error occurred during auth. Try again later'
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: 'Successfully logged out!'
    end
  end
end
