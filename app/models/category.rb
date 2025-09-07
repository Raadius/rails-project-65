# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :bulletins, dependent: :restrict_with_exception
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }
end
