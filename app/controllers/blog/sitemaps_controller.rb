# frozen_string_literal: true

module Blog
  class SitemapsController < ApplicationController
    def show
      @posts = Post.all
      @tags = Tag.all
      respond_to do |format|
        format.xml
      end
    end
  end
end
