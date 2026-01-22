# pixelhandler-blog

```bash
bin/setup         # Install dependencies
bin/dev           # Start development server (Rails + Tailwind watcher)
```

This project uses `mise` for version management. Versions are defined in `.tool-versions`:

```bash
mise install      # Install correct Ruby/Node versions
```

Uses Standard Ruby for consistent code formatting:

```bash
bin/standardrb       # Run linter
bin/standardrb --fix # Auto-fix violations
```

```bash
bin/rails test                    # Run all tests
bin/rails test test/models/       # Run model tests
bin/rails test:system             # Run system tests
```