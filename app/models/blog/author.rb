# frozen_string_literal: true

# Non-ActiveRecord model for authors stored as YAML files
# Loads author profiles from content/authors/*.yml
#
# Usage:
#   Blog::Author.all                       # All authors
#   Blog::Author.find_by_slug('pixelhandler')  # Find by slug
#
module Blog
  class Author
    AUTHORS_PATH = Rails.root.join("content/authors")

    class << self
      def all
        reload! if Rails.env.local?
        @authors ||= load_authors
      end

      def find_by_slug(slug)
        all.find { |author| author.slug == slug.to_s }
      end

      def reload!
        @authors = nil
      end

      private

      def load_authors
        return [] unless AUTHORS_PATH.exist?

        Dir.glob(AUTHORS_PATH.join("*.yml")).filter_map do |file_path|
          parse_file(file_path)
        rescue => e
          Rails.logger.error("Failed to parse author: #{file_path} - #{e.message}")
          nil
        end
      end

      def parse_file(file_path)
        content = YAML.safe_load_file(file_path, permitted_classes: [Date]) || {}
        slug = File.basename(file_path, ".yml")
        new(**content.transform_keys(&:to_sym).merge(slug:))
      end
    end

    attr_reader :slug, :name, :email, :bio, :avatar, :website, :github, :twitter, :linkedin

    def initialize(slug:, name: nil, email: nil, bio: nil, avatar: nil, website: nil, github: nil, twitter: nil, linkedin: nil)
      @slug = slug
      @name = name || slug.titleize
      @email = email
      @bio = bio
      @avatar = avatar
      @website = website
      @github = github
      @twitter = twitter
      @linkedin = linkedin
    end

    def posts
      @posts ||= Post.all.select { |post| post.author == slug }
    end

    def to_param
      slug
    end
  end
end
