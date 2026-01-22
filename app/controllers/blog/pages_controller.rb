# frozen_string_literal: true

module Blog
  class PagesController < ApplicationController
    def about
      @author = Author.find_by_slug('pixelhandler')
      @tags = Tag.with_post_counts.first(15)
    end
  end
end
