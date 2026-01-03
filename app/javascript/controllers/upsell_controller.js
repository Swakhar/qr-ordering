import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "items"]
  static values = {
    restaurantSlug: String,
    currency: String
  }

  connect() {
    // Listen for cart updates to fetch new upsells
    document.addEventListener("cart:updated", (event) => {
      this.fetchUpsells(event.detail.itemIds)
    })
  }

  async fetchUpsells(itemIds) {
    if (!itemIds || itemIds.length === 0) {
      this.hideUpsells()
      return
    }

    try {
      const response = await fetch(`/r/${this.restaurantSlugValue}/upsell`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: JSON.stringify({ item_ids: itemIds })
      })

      if (response.ok) {
        const suggestions = await response.json()
        this.displayUpsells(suggestions)
      }
    } catch (error) {
      console.error("Failed to fetch upsells:", error)
    }
  }

  displayUpsells(suggestions) {
    if (!suggestions || suggestions.length === 0) {
      this.hideUpsells()
      return
    }

    const currencySymbol = this.currencyValue === "EUR" ? "€" : this.currencyValue
    
    const html = suggestions.map(item => `
      <div class="bg-white rounded-lg shadow-sm p-3 flex items-center gap-3">
        ${item.image_url ? `
          <img src="${item.image_url}" 
               alt="${item.name}" 
               class="w-16 h-16 object-cover rounded-lg flex-shrink-0">
        ` : ''}
        <div class="flex-grow min-w-0">
          <h4 class="font-semibold text-gray-900 text-sm truncate">${item.name}</h4>
          <p class="text-sm font-medium text-gray-700">${(item.price_cents / 100).toFixed(2)} ${currencySymbol}</p>
        </div>
        <button 
          class="flex-shrink-0 px-3 py-2 bg-gray-900 text-white text-xs font-medium rounded-lg hover:bg-gray-800 transition-colors"
          data-action="click->upsell#addToCart"
          data-upsell-item-id-param="${item.id}">
          Add
        </button>
      </div>
    `).join('')

    this.itemsTarget.innerHTML = html
    this.containerTarget.classList.remove('hidden')
  }

  hideUpsells() {
    this.containerTarget.classList.add('hidden')
  }

  addToCart(event) {
    const itemId = event.params.itemId
    // Dispatch event to cart controller
    const cartEvent = new CustomEvent("upsell:add", {
      detail: { itemId: itemId }
    })
    document.dispatchEvent(cartEvent)
  }
}
