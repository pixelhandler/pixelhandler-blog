# frozen_string_literal: true

# Non-ActiveRecord model for tags aggregated from blog posts
# Tags are extracted from post frontmatter and deduplicated
#
# Usage:
#   Blog::Tag.all                    # All unique tags
#   Blog::Tag.find_by_slug('ruby')   # Find tag by slug
#   Blog::Tag.with_post_counts       # Tags with post counts
#
module Blog
  class Tag
    class << self
      def all
        Post.all.flat_map(&:tags).uniq.sort.map { |name| new(name:) }
      end

      def find_by_slug(slug)
        all.find { |tag| tag.slug == slug.to_s.parameterize }
      end

      def with_post_counts
        counts = Post.all.flat_map(&:tags).tally
        counts.map { |name, count| new(name:, post_count: count) }
          .sort_by { |tag| [-tag.post_count, tag.name] }
      end
    end

    attr_reader :name, :post_count

    def initialize(name:, post_count: nil)
      @name = name
      @post_count = post_count || posts.size
    end

    def slug
      @slug ||= name.parameterize
    end

    def posts
      @posts ||= Post.by_tag(slug)
    end

    def to_param
      slug
    end
  end
end
