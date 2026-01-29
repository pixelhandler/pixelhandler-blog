# frozen_string_literal: true

namespace :content do
  desc "Migrate posts from pixelhandler.dev API to local markdown files"
  task migrate: :environment do
    require "http"
    require "fileutils"
    require "json"

    api_base = "https://pixelhandler.dev/api/v1"
    posts_dir = Rails.root.join("content/posts")
    authors_dir = Rails.root.join("content/authors")

    FileUtils.mkdir_p(posts_dir)
    FileUtils.mkdir_p(authors_dir)

    puts "Fetching posts from API..."

    # Fetch all posts with pagination (skip SSL verification for migration)
    ctx = OpenSSL::SSL::SSLContext.new
    ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE

    all_posts = []
    included_data = []
    offset = 0
    limit = 20

    loop do
      # Use correct JSON:API params with includes
      # Note: Don't use fields[posts] filter as it strips out relationships
      url = "#{api_base}/posts?sort=-date&page%5Blimit%5D=#{limit}&page%5Boffset%5D=#{offset}&include=tags"
      puts "Fetching posts (offset=#{offset})..."
      response = HTTP.get(url, ssl_context: ctx)

      unless response.status.success?
        puts "Failed to fetch posts: #{response.status}"
        exit 1
      end

      data = JSON.parse(response.body.to_s)
      posts = data["data"] || []
      break if posts.empty?

      all_posts.concat(posts)
      included_data.concat(data["included"] || [])
      offset += limit

      # Safety limit
      break if offset > 200
    end

    # Build a lookup for included tags
    tags_lookup = {}
    included_data.each do |item|
      if item["type"] == "tags"
        tags_lookup[item["id"]] = item.dig("attributes", "name") || item["id"]
      end
    end

    puts "Found #{all_posts.size} posts total"

    all_posts.each do |post|
      attrs = post["attributes"]
      slug = attrs["slug"]
      date_str = attrs["date"] || attrs["published_at"] || attrs["created_at"]
      date = begin
        Date.parse(date_str.to_s)
      rescue
        Date.today
      end
      filename = "#{date.strftime("%Y-%m-%d")}-#{slug}.md"

      # Extract tags from relationships using the lookup
      tag_refs = post.dig("relationships", "tags", "data") || []
      tags = tag_refs.map { |t| tags_lookup[t["id"]] }.compact

      frontmatter = {
        "title" => attrs["title"],
        "slug" => slug,
        "published_at" => date.to_s,
        "author" => "pixelhandler",
        "tags" => tags,
        "meta_description" => (attrs["excerpt"] || attrs["summary"])&.truncate(160)
      }.compact

      # Get the body content
      body = attrs["body"] || attrs["content"] || ""

      # to_yaml already adds '---' at the beginning
      content = "#{frontmatter.to_yaml}---\n\n#{body}"

      file_path = posts_dir.join(filename)
      File.write(file_path, content)
      puts "Created: #{filename}"
    end

    puts "\nMigration complete! #{all_posts.size} posts created."
  end

  desc "List all posts"
  task list: :environment do
    posts = Blog::Post.all
    puts "Found #{posts.size} posts:\n\n"
    posts.each do |post|
      puts "  #{post.published_at} - #{post.title}"
      puts "    Slug: #{post.slug}"
      puts "    Tags: #{post.tags.join(", ")}" if post.tags.any?
      puts ""
    end
  end

  desc "Show post statistics"
  task stats: :environment do
    posts = Blog::Post.all
    tags = Blog::Tag.with_post_counts

    puts "Blog Statistics"
    puts "=" * 40
    puts "Total posts: #{posts.size}"
    puts "Total unique tags: #{tags.size}"
    puts ""
    puts "Tags by post count:"
    tags.first(10).each do |tag|
      puts "  #{tag.name}: #{tag.post_count} posts"
    end
  end

  private

  def extract_tags(post, tags_lookup)
    relationships = post["relationships"] || {}
    tags_data = relationships["tags"] || {}
    tag_refs = tags_data["data"] || []

    tag_refs.map { |t| tags_lookup[t["id"]] }.compact
  rescue
    []
  end
end
