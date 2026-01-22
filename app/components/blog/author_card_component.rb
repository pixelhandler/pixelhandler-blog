# frozen_string_literal: true

module Blog
  class AuthorCardComponent < ViewComponent::Base
    attr_reader :author, :compact

    def initialize(author:, compact: false)
      @author = author
      @compact = compact
    end

    def gravatar_url
      'https://s.gravatar.com/avatar/201e47df9aaf250e6aa21fd2fbe6b287?s=100&r=g'
    end
  end
end
