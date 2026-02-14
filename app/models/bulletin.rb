# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  belongs_to :category
  belongs_to :user
  has_one_attached :image

  validates :title, presence: true, length: { min: 3, maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, attached: true, content_type: %i[png jpg jpeg], size: { less_than: 5.megabytes }

  def self.ransackable_attributes(_auth_object = nil)
    %w[title state created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  # AASM state
  aasm column: :state, whiny_transitions: true do
    state :draft, initial: true
    state :under_moderation
    state :published
    state :rejected
    state :archived

    event :submit_for_moderation do
      transitions from: %i[draft rejected], to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: %i[draft rejected published under_moderation], to: :archived
    end

    event :restore_from_archive do
      transitions from: :archived, to: :draft
    end
  end

  # Scopes для удобной выборки
  scope :published_only, -> { where(state: 'published') }
  scope :for_moderation, -> { where(state: 'under_moderation') }
  scope :by_user, ->(user) { where(user: user) }
  scope :recent, -> { order(created_at: :desc) }
end
