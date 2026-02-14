# frozen_string_literal: true

require 'test_helper'

class BulletinTest < ActiveSupport::TestCase
  setup do
    @bulletin = bulletins(:draft_bulletin)
    @published_bulletin = bulletins(:published_bulletin)
    @rejected_bulletin = bulletins(:rejected_bulletin)
    @under_moderation_bulletin = bulletins(:under_moderation_bulletin)
    @archived_bulletin = bulletins(:archived_bulletin)
  end

  test 'new bulletin should be in draft state by default' do
    bulletin = Bulletin.new(
      title: 'Test Title',
      description: 'Test Description',
      category: categories(:one),
      user: users(:one)
    )
    assert bulletin.draft?
  end

  test 'can submit draft bulletin for moderation' do
    assert @bulletin.draft?
    assert @bulletin.may_submit_for_moderation?

    @bulletin.submit_for_moderation

    assert @bulletin.under_moderation?
  end

  test 'can not publish draft bulletin directly' do
    assert @bulletin.draft?
    assert_not @bulletin.may_publish?
  end

  test 'can publish bulletin under moderation' do
    bulletin = bulletins(:under_moderation_bulletin)
    assert bulletin.under_moderation?
    assert bulletin.may_publish?

    bulletin.publish

    assert bulletin.published?
  end

  test 'can reject bulletin under moderation' do
    bulletin = bulletins(:under_moderation_bulletin)
    assert bulletin.under_moderation?
    assert bulletin.may_reject?

    bulletin.reject

    assert bulletin.rejected?
  end

  test 'can archive bulletin in any state' do
    draft_bulletin = bulletins(:draft_bulletin)
    assert draft_bulletin.may_archive?
    draft_bulletin.archive
    assert draft_bulletin.archived?

    published_bulletin = bulletins(:published_bulletin)
    assert published_bulletin.may_archive?
    published_bulletin.archive
    assert published_bulletin.archived?

    under_moderation_bulletin = bulletins(:under_moderation_bulletin)
    assert under_moderation_bulletin.may_archive?
    under_moderation_bulletin.archive
    assert under_moderation_bulletin.archived?

    rejected_bulletin = bulletins(:rejected_bulletin)
    assert rejected_bulletin.may_archive?
    rejected_bulletin.archive
    assert rejected_bulletin.archived?
  end

  test 'can restore bulletin from archive state' do
    archived_bulletin = bulletins(:archived_bulletin)
    assert archived_bulletin.archived?
    assert archived_bulletin.may_restore_from_archive?

    archived_bulletin.restore_from_archive

    assert archived_bulletin.draft?
  end

  test 'published only scope returns only published bulletins' do
    published = Bulletin.published_only

    assert_includes published, bulletins(:published_bulletin)
    assert_not_includes published, bulletins(:archived_bulletin)
    assert_not_includes published, bulletins(:under_moderation_bulletin)
    assert_not_includes published, bulletins(:rejected_bulletin)
    assert_not_includes published, bulletins(:draft_bulletin)
  end

  test 'for_moderation scope returns only bulletins under moderation' do
    under_moderation = Bulletin.for_moderation

    assert_includes under_moderation, bulletins(:under_moderation_bulletin)
    assert_not_includes under_moderation, bulletins(:draft_bulletin)
    assert_not_includes under_moderation, bulletins(:published_bulletin)
    assert_not_includes under_moderation, bulletins(:rejected_bulletin)
    assert_not_includes under_moderation, bulletins(:archived_bulletin)
  end

  test 'cannot publish bulletin that is already published' do
    assert_not @published_bulletin.may_publish?
  end

  test 'cannot submit published bulletin for moderation' do
    assert_not @published_bulletin.may_submit_for_moderation?
  end

  test 'raise error on invalid transition' do
    assert_raises(AASM::InvalidTransition) do
      @bulletin.publish
    end
  end
end
