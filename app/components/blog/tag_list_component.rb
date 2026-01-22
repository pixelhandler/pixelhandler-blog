# frozen_string_literal: true

module Blog
  class TagListComponent < ViewComponent::Base
    attr_reader :tags, :title

    def initialize(tags:, title: nil)
      @tags = tags
      @title = title
    end
  end
end
