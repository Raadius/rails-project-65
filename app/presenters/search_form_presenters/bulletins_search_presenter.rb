# frozen_string_literal: true

module SearchFormPresenters
  class BulletinsSearchPresenter < SearchFormPresenter
    def initialize(categories)
      @url = Rails.application.routes.url_helpers.root_path
      @categories = categories
    end

    def select?
      true
    end

    def select_field
      :category_id_eq
    end

    def select_label
      I18n.t('search.category_placeholder')
    end

    def select_blank
      I18n.t('search.all_categories')
    end

    def select_options
      @categories.map { |c| [c.name, c.id] }
    end
  end
end
