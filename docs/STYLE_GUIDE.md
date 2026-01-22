# Style Guide

This guide establishes coding standards for the pixelhandler-blog project. Following these conventions ensures consistent, maintainable code.

## Purpose

- Maintain consistent code style across the codebase
- Provide clear guidance for contributors and AI assistants
- Reduce cognitive load when reading and reviewing code

## Ruby Style Guide

### Standard Ruby

This project uses [Standard Ruby](https://github.com/standardrb/standard) for linting. Standard enforces a consistent style without configuration debates.

```bash
bin/standardrb       # Check for violations
bin/standardrb --fix # Auto-fix violations
```

### Key Conventions

**String quotes**: Use double quotes for strings.

```ruby
# Good
name = "pixelhandler"

# Avoid
name = 'pixelhandler'
```

**Indentation**: 2 spaces, no tabs.

```ruby
# Good
def example
  if condition
    do_something
  end
end
```

**Naming conventions**:
- `snake_case` for methods and variables
- `CamelCase` for classes and modules
- `SCREAMING_SNAKE_CASE` for constants

```ruby
# Good
class BlogPost
  MAX_TITLE_LENGTH = 200

  def formatted_title
    title.titleize
  end
end
```

**Line length**: Keep lines under 120 characters. Break long lines at logical points.

**Method length**: Aim for methods under 10 lines. Extract helpers for complex logic.

### Ruby Best Practices

**Frozen string literals**: Include in every Ruby file.

```ruby
# frozen_string_literal: true

module Blog
  class Post
    # ...
  end
end
```

**Guard clauses**: Prefer early returns over nested conditionals.

```ruby
# Good
def process(item)
  return if item.nil?
  return if item.invalid?

  item.save
end

# Avoid
def process(item)
  if item && item.valid?
    item.save
  end
end
```

**Trailing commas**: Use in multi-line arrays and hashes for cleaner diffs.

```ruby
# Good
config = {
  title: "Blog",
  author: "pixelhandler",
}
```

## ViewComponent Style

### Component Structure

Each component lives in `app/components/blog/` with a Ruby class and ERB template:

```ruby
# app/components/blog/card_component.rb
# frozen_string_literal: true

module Blog
  class CardComponent < ViewComponent::Base
    attr_reader :title, :body

    def initialize(title:, body:)
      @title = title
      @body = body
    end
  end
end
```

```erb
<%# app/components/blog/card_component.html.erb %>
<article class="card">
  <h2><%= title %></h2>
  <div class="card-body">
    <%= body %>
  </div>
</article>
```

### Component Guidelines

1. **Single responsibility**: Each component renders one distinct UI element
2. **Keyword arguments**: Use keyword args for clarity in `initialize`
3. **Read-only attributes**: Use `attr_reader`, not `attr_accessor`
4. **No database queries**: Components receive data, they don't fetch it
5. **Semantic HTML**: Use appropriate elements (`article`, `nav`, `section`)

### Generating Components

```bash
bin/rails generate component Blog::ExampleComponent title --sidecar
```

## JavaScript Style Guide

### Hotwire Philosophy

This project uses the Hotwire stack (Turbo + Stimulus). JavaScript enhances server-rendered HTML rather than replacing it.

**Principles**:
- HTML over the wire, not JSON
- Progressive enhancement
- Server-first logic
- Minimal client-side state

### Stimulus Controllers

Controllers live in `app/javascript/controllers/` and follow these patterns:

```javascript
import { Controller } from "@hotwired/stimulus"

// Clear docblock explaining purpose
// Example: Theme controller for dark/light mode toggle
export default class extends Controller {
  static targets = ["icon"]
  static values = { theme: String }

  connect() {
    // Initialize on DOM connection
  }

  toggle() {
    // Action methods are verbs
  }
}
```

**Naming conventions**:
- File: `theme_controller.js` (snake_case)
- HTML: `data-controller="theme"` (kebab-case)
- Targets: `data-theme-target="icon"` (kebab-case with controller prefix)

**Controller guidelines**:
1. Keep controllers focused on one concern
2. Use targets over query selectors
3. Use values for reactive state
4. Actions should be verbs (`toggle`, `submit`, `open`)
5. Store user preferences in localStorage, not cookies

### Turbo Patterns

**Turbo Drive** handles page navigation automatically. All internal links use Turbo for fast transitions.

**Turbo Frames** can scope updates to parts of the page:

```erb
<%= turbo_frame_tag "search_results" do %>
  <%= render partial: "results", locals: { posts: @posts } %>
<% end %>
```

## ERB Template Style

### Formatting

**Indentation**: 2 spaces, matching Ruby.

```erb
<article class="post">
  <header>
    <h1><%= @post.title %></h1>
  </header>

  <div class="content">
    <%= @post.content_html %>
  </div>
</article>
```

**Partials**: Use underscored names, pass explicit locals.

```erb
<%# Good %>
<%= render "shared/header", title: @page_title %>

<%# Avoid implicit instance variables in partials %>
```

### ERB Guidelines

1. **Minimal logic**: Move complex conditionals to helpers or components
2. **Semantic HTML**: Use `article`, `section`, `nav`, `aside` appropriately
3. **Accessibility**: Include alt text, ARIA labels, proper heading hierarchy
4. **Component preference**: Use ViewComponents for reusable UI elements

## Tailwind CSS Style

### Class Organization

Order utility classes logically:

1. Layout (display, position, flexbox/grid)
2. Sizing (width, height, padding, margin)
3. Typography (font, text, color)
4. Visual (background, border, shadow)
5. Interactive (hover, focus, transition)

```erb
<button class="flex items-center gap-2 px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition-colors">
  Submit
</button>
```

### Theme Support

This project supports dark/light modes via `data-theme` attribute:

```css
/* app/assets/tailwind/themes/light.css */
[data-theme="light"] {
  --color-background: #ffffff;
}

/* app/assets/tailwind/themes/dark.css */
[data-theme="dark"] {
  --color-background: #1a1a1a;
}
```

Use CSS variables for theme-dependent colors rather than Tailwind's `dark:` prefix.

## AI Code Generation Guidelines

When generating code for this project:

### Do

- Follow Standard Ruby conventions (double quotes, 2-space indent)
- Use ViewComponents for reusable UI elements
- Keep Stimulus controllers focused and minimal
- Use semantic HTML elements
- Prefer server-rendered HTML over client-side JavaScript
- Add `frozen_string_literal: true` to Ruby files

### Don't

- Add database migrations (this is a file-based blog)
- Create complex JavaScript interactions
- Use single quotes for Ruby strings
- Add gems without explicit approval
- Over-engineer simple features
- Add authentication or user management code

### Code Review Checklist

Before submitting code:

- [ ] Passes `bin/standardrb` with no violations
- [ ] No hardcoded strings that should be content
- [ ] Components have appropriate accessibility attributes
- [ ] New Stimulus controllers are registered in `index.js`
- [ ] Follows existing patterns in the codebase
