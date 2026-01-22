# frozen_string_literal: true

module Blog
  class SidebarComponent < ViewComponent::Base
    attr_reader :tags, :show_search, :show_about

    def initialize(tags: [], show_search: true, show_about: true)
      @tags = tags
      @show_search = show_search
      @show_about = show_about
    end

    def author
      @author ||= Author.find_by_slug('pixelhandler')
    end
  end
end
