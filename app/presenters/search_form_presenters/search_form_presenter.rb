# frozen_string_literal: true

module SearchFormPresenters
  class SearchFormPresenter
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def select?
      false
    end

    def select_field; end
    def select_label; end
    def select_blank; end
    def select_options; end
  end
end
