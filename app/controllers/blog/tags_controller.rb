# frozen_string_literal: true

module Blog
  class TagsController < ApplicationController
    def index
      @tags = Tag.with_post_counts
    end

    def show
      @tag = Tag.find_by_slug(params[:slug])
      return redirect_to tags_path, alert: t('blog.tags.not_found') unless @tag

      @posts = @tag.posts
      @tags = Tag.with_post_counts.first(15)
    end
  end
end
