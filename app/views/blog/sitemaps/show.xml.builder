xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  # Homepage
  xml.url do
    xml.loc root_url
    xml.changefreq "weekly"
    xml.priority 1.0
  end

  # About page
  xml.url do
    xml.loc about_url
    xml.changefreq "monthly"
    xml.priority 0.8
  end

  # Posts index
  xml.url do
    xml.loc posts_url
    xml.changefreq "weekly"
    xml.priority 0.9
  end

  # Individual posts
  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.published_at.to_date.iso8601
      xml.changefreq "monthly"
      xml.priority 0.7
    end
  end

  # Tags index
  xml.url do
    xml.loc tags_url
    xml.changefreq "weekly"
    xml.priority 0.6
  end

  # Individual tags
  @tags.each do |tag|
    xml.url do
      xml.loc tag_url(tag)
      xml.changefreq "weekly"
      xml.priority 0.5
    end
  end
end
