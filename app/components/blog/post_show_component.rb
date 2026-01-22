# frozen_string_literal: true

module Blog
  class PostShowComponent < ViewComponent::Base
    attr_reader :post

    def initialize(post:)
      @post = post
    end

    def author
      @author ||= post.author_model
    end
  end
end
