# AI Agent Context for pixelhandler-blog

This document provides context for AI coding assistants working on this project.

**Related documentation**: See [docs/STYLE_GUIDE.md](docs/STYLE_GUIDE.md) for coding conventions and style rules.

## Architecture Overview

**pixelhandler-blog** is a file-based blog engine built with Rails 8. Instead of using a database, blog posts and author information are stored as YAML frontmatter + Markdown files in the `content/` directory.

### Key Architectural Decisions

- **File-based content**: Posts in `content/posts/*.md`, authors in `content/authors/*.yml`
- **No database**: Models (`Blog::Post`, `Blog::Author`, `Blog::Tag`) are Ruby classes that parse files
- **ViewComponent**: UI components in `app/components/blog/` for reusable, testable view logic
- **Hotwire stack**: Turbo for page navigation, Stimulus for JavaScript sprinkles
- **Tailwind CSS**: Utility-first styling with custom theme support (dark/light modes)
- **Importmaps**: No JavaScript bundler; ES modules loaded directly

### Directory Structure

```
content/
├── posts/           # Markdown blog posts with YAML frontmatter
└── authors/         # Author YAML files

app/
├── components/blog/ # ViewComponent components
├── controllers/blog/ # Namespaced controllers
├── models/blog/     # File-based models (Post, Author, Tag, PaginatedCollection)
├── views/blog/      # View templates
└── javascript/controllers/ # Stimulus controllers
```

## Setup

### Development Server

```bash
bin/setup         # Install dependencies
bin/dev           # Start development server (Rails + Tailwind watcher)
```

### Version Management

This project uses `mise` for version management. Versions are defined in `.tool-versions`:

```bash
mise install      # Install correct Ruby/Node versions
```

### Linting

Uses Standard Ruby for consistent code formatting:

```bash
bin/standardrb       # Run linter
bin/standardrb --fix # Auto-fix violations
```

### Testing

```bash
bin/rails test                    # Run all tests
bin/rails test test/models/       # Run model tests
bin/rails test:system             # Run system tests
```

## Patterns

### Rails Conventions

- Follow Rails 8 conventions and idioms
- Use `frozen_string_literal: true` in all Ruby files
- Namespaced modules under `Blog::` for domain objects
- Routes are RESTful where possible

### ViewComponent

Components live in `app/components/blog/` with the pattern:

```ruby
# app/components/blog/example_component.rb
module Blog
  class ExampleComponent < ViewComponent::Base
    attr_reader :item

    def initialize(item:)
      @item = item
    end
  end
end
```

```erb
<%# app/components/blog/example_component.html.erb %>
<div class="example">
  <%= item.name %>
</div>
```

### Hotwire / Stimulus

Three Stimulus controllers handle JavaScript functionality:

- `theme_controller.js` - Dark/light mode toggle with localStorage persistence
- `sidebar_controller.js` - Mobile sidebar open/close
- `search_controller.js` - Form auto-submit on search input

Controllers follow Stimulus conventions:
- Targets for DOM element references
- Actions for event handling
- Values for reactive data

### File-Based Models

Models don't inherit from ActiveRecord. They parse content files:

```ruby
Blog::Post.all                    # All posts, sorted by date
Blog::Post.find_by_slug('slug')   # Find by URL slug
Blog::Post.by_tag('tag')          # Filter by tag
Blog::Post.search('query')        # Search title/tags/excerpt
```

## Troubleshooting

### JavaScript/Stimulus Issues

If Stimulus controllers aren't loading:

1. Check `app/javascript/controllers/index.js` registers the controller
2. Clear asset cache: `bin/rails assets:clobber`
3. Check browser console for import errors
4. Verify importmap pins in `config/importmap.rb`

### Tailwind CSS Not Updating

1. Ensure `bin/dev` is running (starts Tailwind watcher)
2. Check `app/assets/tailwind/application.css` for correct imports
3. Restart the Tailwind build: `bin/rails tailwindcss:build`

### Content Changes Not Reflecting

Posts are cached in memory. In development, they reload automatically. If issues persist:

1. Restart the Rails server
2. Check file permissions on `content/` directory
3. Verify frontmatter YAML syntax is valid

## Documentation Standards

### Date Formats

- User-facing dates: "January 21, 2026" format
- Frontmatter dates: `YYYY-MM-DD` format (e.g., `2026-01-21`)
- File names: `YYYY-MM-DD-slug.md` pattern

### Frontmatter Schema

```yaml
---
title: "Post Title"
slug: optional-custom-slug
published_at: 2026-01-21
author: pixelhandler
tags:
  - tag1
  - tag2
meta_description: "SEO description"
og_image: /path/to/image.jpg
---
```

## Guidance

### Decision-Making Heuristics

When making implementation decisions:

1. **Simplicity over cleverness** - This is a blog, not enterprise software
2. **File-based first** - Resist urges to add a database
3. **Minimal JavaScript** - Use Stimulus for progressive enhancement only
4. **Semantic HTML** - Accessibility and SEO matter for a blog
5. **Content is king** - Features should serve the reading experience

### Key Principles

Follow Sandi Metz's rules for clean code:

1. Classes should be no longer than 100 lines
2. Methods should be no longer than 5 lines (guideline, not strict)
3. Pass no more than 4 parameters to a method
4. Controllers should only instantiate one object

### Object-Oriented Design

- Prefer composition over inheritance
- Single Responsibility Principle: each class does one thing well
- Keep public interfaces small
- Name things clearly; avoid abbreviations

### Performance Considerations

- Posts are loaded into memory on first access
- Keep the number of posts reasonable (< 500 recommended)
- Images should be hosted externally or in `/public`
- Use Turbo Drive for fast page transitions
