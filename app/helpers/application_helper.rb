# frozen_string_literal: true

module ApplicationHelper
  def state_badge_class(state)
    case state
    when 'under_moderation'
      'bg-warning text-dark'
    when 'published'
      'bg-success'
    when 'rejected'
      'bg-danger'
    when 'archived'
      'bg-dark'
    else
      'bg-secondary'
    end
  end

  def flash_class(type)
    case type
    when 'notice'
      'alert-success'
    when 'alert'
      'alert-danger'
    else
      'alert-info'
    end
  end
end
