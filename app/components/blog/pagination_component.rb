# frozen_string_literal: true

module Blog
  class PaginationComponent < ViewComponent::Base
    attr_reader :collection, :path_helper, :search_query

    def initialize(collection:, path_helper: :posts_path, search_query: nil)
      @collection = collection
      @path_helper = path_helper
      @search_query = search_query
    end

    def render?
      collection.total_pages > 1
    end

    def page_url(page)
      params = { page: page }
      params[:search] = search_query if search_query.present?
      helpers.send(path_helper, params)
    end

    def previous_url
      page_url(collection.previous_page) if collection.previous_page
    end

    def next_url
      page_url(collection.next_page) if collection.next_page
    end
  end
end
