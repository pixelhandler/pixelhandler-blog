import { Controller } from '@hotwired/stimulus'

// Sidebar controller for mobile-responsive collapsible sidebar
export default class extends Controller {
  static targets = ['panel', 'icon']

  toggle() {
    if (!this.hasPanelTarget) return

    this.panelTarget.classList.toggle('hidden')
    this.panelTarget.classList.toggle('lg:block')

    if (this.hasIconTarget) {
      const isVisible = !this.panelTarget.classList.contains('hidden')
      this.iconTarget.className = isVisible
        ? 'icon-[tabler--x] size-5'
        : 'icon-[tabler--layout-sidebar-right] size-5'
    }
  }

  // Close sidebar when pressing Escape
  close(event) {
    if (event.key === 'Escape' && this.hasPanelTarget) {
      this.panelTarget.classList.add('hidden')
      this.panelTarget.classList.remove('lg:block')
      if (this.hasIconTarget) {
        this.iconTarget.className = 'icon-[tabler--layout-sidebar-right] size-5'
      }
    }
  }
}
