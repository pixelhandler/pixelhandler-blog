# pixelhandler archive

This repository now serves a static archive page. The root page is the former
Rails `404.html` page, copied to `public/index.html`; requests for missing files
also use `public/404.html`.

The site is served by Nginx from `public/` in the Docker image. There is no
Rails runtime or build step. Historical Markdown posts in `content/` remain in
the repository as source archives and are not part of the deployed image.
