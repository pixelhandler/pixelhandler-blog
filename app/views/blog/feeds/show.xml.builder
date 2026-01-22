xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.feed xmlns: "http://www.w3.org/2005/Atom" do
  xml.title t("blog.site.title")
  xml.subtitle t("blog.site.description")
  xml.link href: root_url, rel: "alternate", type: "text/html"
  xml.link href: feed_url(format: :xml), rel: "self", type: "application/atom+xml"
  xml.id root_url
  xml.updated @posts.first&.published_at&.to_datetime&.iso8601 || Time.current.iso8601
  xml.author do
    xml.name "Billy Heaton"
    xml.email "pixelhandler@gmail.com"
    xml.uri "https://pixelhandler.dev"
  end

  @posts.each do |post|
    xml.entry do
      xml.title post.title
      xml.link href: post_url(post), rel: "alternate", type: "text/html"
      xml.id post_url(post)
      xml.published post.published_at.to_datetime.iso8601
      xml.updated post.published_at.to_datetime.iso8601
      xml.author do
        xml.name post.author_model&.name || "Billy Heaton"
      end

      if post.tags.any?
        post.tags.each do |tag|
          xml.category term: tag
        end
      end

      xml.summary post.excerpt, type: "text"
      xml.content post.content_html, type: "html"
    end
  end
end
