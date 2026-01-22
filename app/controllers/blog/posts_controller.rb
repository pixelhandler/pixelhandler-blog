# frozen_string_literal: true

module Blog
  class PostsController < ApplicationController
    def index
      @search_query = params[:search]
      posts = @search_query.present? ? Post.search(@search_query) : Post.all
      @posts = Post.paginate(posts, page: params[:page], per_page: 10)
      @tags = Tag.with_post_counts.first(15)
    end

    def show
      @post = Post.find_by_slug(params[:slug])
      return redirect_to posts_path, alert: t("blog.posts.not_found") unless @post

      @tags = Tag.with_post_counts.first(15)
      @related_posts = find_related_posts(@post).first(3)
    end

    private

    def find_related_posts(post)
      return [] if post.tags.empty?

      Post.all
        .reject { |p| p.slug == post.slug }
        .select { |p| (p.tags & post.tags).any? }
        .sort_by { |p| -(p.tags & post.tags).size }
    end
  end
end
