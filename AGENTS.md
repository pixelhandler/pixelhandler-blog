# AI Agent Context

This repository is a static archive served by Nginx. `public/index.html` is the
site homepage and mirrors `public/404.html`; Nginx also returns that 404 page
when a requested file does not exist.

The Docker image copies `public/` into the Nginx document root. Update the
static files or `nginx/default.conf` when changing the site. Historical Markdown
posts in `content/` are retained as source archives and are not part of the
deployed image.
