# frozen_string_literal: true

module Blog
  class PaginatedCollection
    include Enumerable

    attr_reader :current_page, :total_pages, :total_count, :per_page

    def initialize(posts:, current_page:, total_pages:, total_count:, per_page:)
      @posts = posts
      @current_page = current_page
      @total_pages = [total_pages, 1].max
      @total_count = total_count
      @per_page = per_page
    end

    def each(&block)
      @posts.each(&block)
    end

    def first_page?
      current_page == 1
    end

    def last_page?
      current_page >= total_pages
    end

    def previous_page
      first_page? ? nil : current_page - 1
    end

    def next_page
      last_page? ? nil : current_page + 1
    end

    def page_range
      # Show up to 5 page numbers centered around current page
      start_page = [current_page - 2, 1].max
      end_page = [start_page + 4, total_pages].min
      start_page = [end_page - 4, 1].max
      (start_page..end_page).to_a
    end
  end
end
