# frozen_string_literal: true

module Blog
  class PostCardComponent < ViewComponent::Base
    attr_reader :post

    def initialize(post:)
      @post = post
    end
  end
end
