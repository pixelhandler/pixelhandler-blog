# frozen_string_literal: true

module Blog
  class FeedsController < ApplicationController
    def show
      @posts = Post.all.first(20)
      respond_to do |format|
        format.xml
      end
    end
  end
end
