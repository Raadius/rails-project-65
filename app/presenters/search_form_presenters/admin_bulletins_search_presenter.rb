# frozen_string_literal: true

module SearchFormPresenters
  class AdminBulletinsSearchPresenter < SearchFormPresenter
    def initialize
      super
      @url = Rails.application.routes.url_helpers.admin_bulletins_path
    end

    def select?
      true
    end

    def select_field
      :state_eq
    end

    def select_label
      I18n.t('search.state_placeholder')
    end

    def select_blank
      I18n.t('search.all_states')
    end

    def select_options
      Bulletin.aasm.states.map { |s| [I18n.t("bulletin.states.#{s.name}"), s.name] }
    end
  end
end
