import { Controller } from '@hotwired/stimulus'

// Search controller for client-side post filtering
// Supports both instant filtering and URL-based search
export default class extends Controller {
  static targets = ['input', 'results', 'post']
  static values = {
    minChars: { type: Number, default: 2 },
    submitOnEnter: { type: Boolean, default: true }
  }

  connect() {
    // Check for search query in URL
    const params = new URLSearchParams(window.location.search)
    const query = params.get('search')
    if (query && this.hasInputTarget) {
      this.inputTarget.value = query
      this.filter()
    }
  }

  filter() {
    if (!this.hasInputTarget) return

    const query = this.inputTarget.value.toLowerCase().trim()

    if (query.length < this.minCharsValue) {
      this.showAll()
      return
    }

    this.postTargets.forEach(post => {
      const title = post.dataset.title?.toLowerCase() || ''
      const tags = post.dataset.tags?.toLowerCase() || ''
      const matches = title.includes(query) || tags.includes(query)
      post.classList.toggle('hidden', !matches)
    })

    this.updateResultsCount(query)
  }

  submit(event) {
    if (event.key === 'Enter' && this.submitOnEnterValue) {
      event.preventDefault()
      const query = this.inputTarget.value.trim()
      if (query) {
        window.location.href = `/?search=${encodeURIComponent(query)}`
      } else {
        window.location.href = '/'
      }
    }
  }

  clear() {
    if (this.hasInputTarget) {
      this.inputTarget.value = ''
      this.showAll()
      // Update URL without search param
      const url = new URL(window.location)
      url.searchParams.delete('search')
      window.history.replaceState({}, '', url)
    }
  }

  showAll() {
    this.postTargets.forEach(post => {
      post.classList.remove('hidden')
    })
    this.updateResultsCount('')
  }

  updateResultsCount(query) {
    if (!this.hasResultsTarget) return

    const visible = this.postTargets.filter(post => !post.classList.contains('hidden')).length
    const total = this.postTargets.length

    if (query) {
      this.resultsTarget.textContent = `${visible} of ${total} posts match "${query}"`
      this.resultsTarget.classList.remove('hidden')
    } else {
      this.resultsTarget.classList.add('hidden')
    }
  }
}
