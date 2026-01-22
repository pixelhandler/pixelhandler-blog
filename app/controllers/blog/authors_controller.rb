# frozen_string_literal: true

module Blog
  class AuthorsController < ApplicationController
    def show
      @author = Author.find_by_slug(params[:slug])
      return redirect_to root_path, alert: t('blog.authors.not_found') unless @author

      @posts = @author.posts
      @tags = Tag.with_post_counts.first(15)
    end
  end
end
