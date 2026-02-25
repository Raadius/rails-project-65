# frozen_string_literal: true

class BulletinPolicy
  attr_reader :user, :bulletin

  def initialize(user, bulletin)
    @user = user
    @bulletin = bulletin
  end

  def show?
    return true if @bulletin.published? || @user&.admin?

    @bulletin.user == @user
  end

  def edit?
    update?
  end

  def update?
    return true if @user.admin?

    @bulletin.user == @user && (@bulletin.draft? || @bulletin.rejected?)
  end

  def create?
    @user.present?
  end

  def new?
    create?
  end

  def author?
    @bulletin.user == @user
  end

  def archive?
    author? || @user&.admin?
  end

  def to_moderate?
    author? || @user&.admin?
  end

  def restore_from_archive?
    author? || @user&.admin?
  end

  def publish?
    @user&.admin?
  end

  def reject?
    @user&.admin?
  end
end

