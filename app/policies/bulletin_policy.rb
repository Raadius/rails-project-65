# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def show?
    record.published? || user&.admin? || author?
  end

  def update?
    author? && (record.draft? || record.rejected?)
  end

  def author?
    record.user == user
  end

  def archive?
    author?
  end

  def to_moderate?
    author?
  end

  def restore_from_archive?
    author?
  end
end
