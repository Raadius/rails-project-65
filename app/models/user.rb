# frozen_string_literal: true

class User < ApplicationRecord
  def self.find_or_create_from_auth(auth)
    user = User.find_or_create_by(email: auth.info.email)
    user.update(
      name: auth.info.name,
      email: auth.info.email
    )
    user
  end
end
