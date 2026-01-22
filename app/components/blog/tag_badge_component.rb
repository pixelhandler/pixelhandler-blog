# frozen_string_literal: true

module Blog
  class TagBadgeComponent < ViewComponent::Base
    attr_reader :tag, :linked, :count

    def initialize(tag:, linked: false, count: nil)
      @tag = tag.is_a?(String) ? tag : tag.name
      @slug = tag.is_a?(String) ? tag.parameterize : tag.slug
      @linked = linked
      @count = count.is_a?(Integer) ? count : (tag.respond_to?(:post_count) ? tag.post_count : nil)
    end

    def slug
      @slug
    end

    def badge_classes
      'inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium ' \
      'bg-aqua-100 text-aqua-800 dark:bg-aqua-900 dark:text-aqua-200 ' \
      'hover:bg-aqua-200 dark:hover:bg-aqua-800 transition-colors'
    end
  end
end
