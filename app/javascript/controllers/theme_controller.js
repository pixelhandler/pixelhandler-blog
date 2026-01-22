import { Controller } from '@hotwired/stimulus'

// Theme controller for dark/light mode toggle
// Respects system preference on first visit, saves user choice to localStorage
export default class extends Controller {
  static targets = ['icon']

  connect() {
    const saved = localStorage.getItem('theme')
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
    const theme = saved || (prefersDark ? 'dark' : 'light')
    this.setTheme(theme)

    // Listen for system preference changes
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
      if (!localStorage.getItem('theme')) {
        this.setTheme(e.matches ? 'dark' : 'light')
      }
    })
  }

  toggle() {
    const current = document.documentElement.dataset.theme || 'light'
    const next = current === 'light' ? 'dark' : 'light'
    this.setTheme(next)
    localStorage.setItem('theme', next)
  }

  setTheme(theme) {
    document.documentElement.dataset.theme = theme

    if (this.hasIconTarget) {
      this.iconTarget.className = theme === 'dark'
        ? 'icon-[tabler--sun] size-5'
        : 'icon-[tabler--moon] size-5'
    }
  }
}
