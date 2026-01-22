# frozen_string_literal: true

# Non-ActiveRecord model for blog posts stored as markdown files
# Parses YAML frontmatter and renders markdown content with syntax highlighting
#
# Usage:
#   Blog::Post.all                    # All posts, sorted by date descending
#   Blog::Post.find_by_slug('slug')   # Find by slug
#   Blog::Post.by_tag('tag')          # Filter by tag
#   Blog::Post.search('query')        # Search by title and tags
#
module Blog
  class Post
    POSTS_PATH = Rails.root.join('content/posts')

    # Allowed HTML tags for sanitization (defense-in-depth after Redcarpet's filter_html)
    ALLOWED_TAGS = %w[
      p br strong em b i ul ol li h1 h2 h3 h4 h5 h6
      a code pre blockquote table thead tbody tr th td
      del sup sub mark hr span div
    ].freeze

    ALLOWED_ATTRIBUTES = %w[href rel target class id].freeze

    class << self
      def all
        reload! if Rails.env.local?
        @posts ||= load_posts
      end

      def find_by_slug(slug)
        all.find { |post| post.slug == slug }
      end

      def by_tag(tag_slug)
        all.select { |post| post.tags.any? { |t| t.parameterize == tag_slug.to_s.parameterize } }
      end

      def search(query)
        return all if query.blank?

        query_downcase = query.downcase
        all.select do |post|
          post.title.downcase.include?(query_downcase) ||
            post.tags.any? { |tag| tag.downcase.include?(query_downcase) } ||
            post.excerpt.downcase.include?(query_downcase)
        end
      end

      def paginate(posts, page:, per_page: 10)
        page = [page.to_i, 1].max
        total_count = posts.size
        total_pages = (total_count / per_page.to_f).ceil
        offset = (page - 1) * per_page

        PaginatedCollection.new(
          posts: posts.slice(offset, per_page) || [],
          current_page: page,
          total_pages: total_pages,
          total_count: total_count,
          per_page: per_page
        )
      end

      def tags
        all.flat_map(&:tags).uniq.sort
      end

      def reload!
        @posts = nil
      end

      private

      def load_posts
        return [] unless POSTS_PATH.exist?

        Dir.glob(POSTS_PATH.join('*.md')).filter_map do |file_path|
          parse_file(file_path)
        rescue => e
          Rails.logger.error("Failed to parse post: #{file_path} - #{e.message}")
          nil
        end.sort_by(&:published_at).reverse
      end

      def parse_file(file_path)
        content = File.read(file_path)
        frontmatter, markdown = extract_frontmatter(content)
        new(frontmatter:, markdown:, file_path:)
      end

      def extract_frontmatter(content)
        return [{}, content] unless content.start_with?('---')

        parts = content.split(/^---\s*$/, 3)
        return [{}, content] if parts.length < 3

        frontmatter = YAML.safe_load(parts[1], permitted_classes: [Date, Time]) || {}
        [frontmatter.transform_keys(&:to_sym), parts[2].strip]
      end
    end

    attr_reader :title, :slug, :published_at, :tags, :author,
      :meta_description, :og_image

    def initialize(frontmatter:, markdown:, file_path:)
      @title = frontmatter[:title]
      @slug = frontmatter[:slug] || File.basename(file_path, '.md').sub(/^\d{4}-\d{2}-\d{2}-/, '')
      @published_at = parse_date(frontmatter[:published_at])
      @tags = Array(frontmatter[:tags])
      @author = frontmatter[:author] || 'pixelhandler'
      @meta_description = frontmatter[:meta_description]
      @og_image = frontmatter[:og_image]
      @markdown = markdown
    end

    def content_html
      @content_html ||= render_markdown(@markdown)
    end

    def excerpt
      @excerpt ||= extract_excerpt
    end

    def reading_time
      words = @markdown.split.size
      minutes = (words / 200.0).ceil
      (minutes < 1) ? 1 : minutes
    end

    def to_param
      slug
    end

    def author_model
      @author_model ||= Blog::Author.find_by_slug(author)
    end

    private

    def parse_date(value)
      return Date.today if value.nil?
      return value.to_date if value.respond_to?(:to_date)
      return value if value.is_a?(Date)

      Date.parse(value.to_s)
    rescue ArgumentError
      Date.today
    end

    def render_markdown(text)
      renderer = RougeRenderer.new(
        filter_html: true,
        hard_wrap: true,
        link_attributes: {target: '_blank', rel: 'noopener noreferrer'}
      )
      markdown = Redcarpet::Markdown.new(
        renderer,
        autolink: true,
        tables: true,
        fenced_code_blocks: true,
        strikethrough: true,
        superscript: true,
        underline: true,
        highlight: true,
        no_intra_emphasis: true
      )
      raw_html = markdown.render(text)

      # Defense-in-depth: sanitize with strict allowlist even though Redcarpet filters HTML
      ActionController::Base.helpers.sanitize(
        raw_html,
        tags: ALLOWED_TAGS,
        attributes: ALLOWED_ATTRIBUTES
      ).html_safe
    end

    # Custom Redcarpet renderer with Rouge syntax highlighting
    class RougeRenderer < Redcarpet::Render::HTML
      def block_code(code, language)
        language = language&.strip&.downcase
        language = nil if language&.empty?

        lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText.new
        formatter = Rouge::Formatters::HTML.new

        highlighted = formatter.format(lexer.lex(code))
        lang_class = language ? " data-language=\"#{language}\"" : ''

        %(<pre class="highlight"#{lang_class}><code>#{highlighted}</code></pre>)
      end
    end

    def extract_excerpt
      first_para = @markdown.split("\n\n").find do |para|
        para.strip.present? && !para.start_with?('#')
      end
      return '' unless first_para

      plain_text = first_para.gsub(/\[([^\]]+)\]\([^)]+\)/, '\1')
      plain_text = plain_text.gsub(/[*_~`#]/, '')
      plain_text.strip.truncate(200)
    end
  end
end
