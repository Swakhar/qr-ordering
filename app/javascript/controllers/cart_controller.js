import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lines", "total", "payload", "submitButton", "itemCount", "cartItems", "toggleButton", "toast", "toastMessage", "form"]
  
  connect() {
    this.lines = {}
    this.render()
    
    // Listen for upsell additions
    document.addEventListener("upsell:add", (event) => {
      this.add({ preventDefault: () => {}, params: { itemId: event.detail.itemId } })
    })
  }

  add(event) {
    event.preventDefault()
    const id = parseInt(event.params.itemId, 10)
    this.lines[id] = (this.lines[id] || 0) + 1
    this.render()
    this.showToast()
    
    // Vibration feedback if supported
    if ('vibrate' in navigator) {
      navigator.vibrate(50)
    }
    
    // Dispatch cart updated event for upsells
    this.dispatchCartUpdate()
  }

  remove(event) {
    event.preventDefault()
    const id = parseInt(event.params.itemId, 10)
    if (!this.lines[id]) return
    this.lines[id]--
    if (this.lines[id] <= 0) delete this.lines[id]
    this.render()
    this.dispatchCartUpdate()
  }

  increment(event) {
    event.preventDefault()
    const id = parseInt(event.params.itemId, 10)
    if (!this.lines[id]) return
    this.lines[id]++
    this.render()
    this.dispatchCartUpdate()
  }

  deleteItem(event) {
    event.preventDefault()
    const id = parseInt(event.params.itemId, 10)
    delete this.lines[id]
    this.render()
    this.dispatchCartUpdate()
  }

  toggleCart(event) {
    event.preventDefault()
    this.cartItemsTarget.classList.toggle('hidden')
    
    // Rotate the toggle icon
    const icon = this.toggleButtonTarget.querySelector('svg')
    icon.style.transform = this.cartItemsTarget.classList.contains('hidden') 
      ? 'rotate(0deg)' 
      : 'rotate(180deg)'
  }

  checkout(event) {
    const entries = Object.entries(this.lines)
    
    if (!entries.length) {
      event.preventDefault()
      alert('Your cart is empty')
      return false
    }
    
    const items = entries.map(([id, qty]) => ({ 
      item_id: parseInt(id, 10), 
      qty 
    }))
    
    // Set the payload
    this.payloadTarget.value = JSON.stringify(items)
    
    // Disable button to prevent double submission
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = true
      this.submitButtonTarget.textContent = 'Submitting...'
    }
    
    // Let the form submit naturally
    return true
  }

  showToast() {
    if (!this.hasToastTarget) return
    
    this.toastTarget.classList.remove('hidden')
    
    setTimeout(() => {
      this.toastTarget.classList.add('hidden')
    }, 2000)
  }

  render() {
    const entries = Object.entries(this.lines)
    const totalItems = entries.reduce((sum, [, qty]) => sum + qty, 0)
    
    // Update item count
    if (this.hasItemCountTarget) {
      this.itemCountTarget.textContent = totalItems > 0 ? `(${totalItems})` : ''
    }
    
    // Enable/disable submit button
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = totalItems === 0
    }
    
    // Render cart lines
    if (!entries.length) {
      this.linesTarget.innerHTML = `<p class="text-sm text-gray-500 italic">${this.getTranslation('cart_empty')}</p>`
      this.totalTarget.textContent = this.formatCurrency(0)
      return
    }

    let html = ""
    let total = 0

    entries.forEach(([id, qty]) => {
      const priceElement = document.querySelector(`[data-item-price='${id}']`)
      const nameElement = document.querySelector(`[data-item-name='${id}']`)
      
      const price = parseInt(priceElement?.dataset.cents || "0", 10)
      const name = nameElement?.dataset.name || `Item #${id}`
      const lineTotal = price * qty
      total += lineTotal

      html += `
        <div class="flex items-center justify-between py-2 px-3 bg-gray-50 rounded-lg">
          <div class="flex-grow">
            <p class="font-medium text-gray-900 text-sm">${name}</p>
            <p class="text-xs text-gray-600">${this.formatCurrency(price)} × ${qty}</p>
          </div>
          
          <div class="flex items-center gap-3">
            <div class="flex items-center gap-2 bg-white rounded-lg border border-gray-300">
              <button 
                data-action="click->cart#remove" 
                data-cart-item-id-param="${id}"
                class="px-2 py-1 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-l-lg transition-colors">
                −
              </button>
              <span class="text-sm font-medium px-2">${qty}</span>
              <button 
                data-action="click->cart#increment" 
                data-cart-item-id-param="${id}"
                class="px-2 py-1 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-r-lg transition-colors">
                +
              </button>
            </div>
            
            <span class="text-sm font-semibold text-gray-900 w-16 text-right">
              ${this.formatCurrency(lineTotal)}
            </span>
            
            <button 
              data-action="click->cart#deleteItem" 
              data-cart-item-id-param="${id}"
              class="text-red-600 hover:text-red-800 transition-colors ml-2"
              title="Remove">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
              </svg>
            </button>
          </div>
        </div>
      `
    })

    this.linesTarget.innerHTML = html
    this.totalTarget.textContent = this.formatCurrency(total)
  }

  formatCurrency(cents) {
    return new Intl.NumberFormat('de-DE', {
      style: 'currency',
      currency: 'EUR'
    }).format(cents / 100)
  }

  getTranslation(key) {
    const translations = {
      'cart_empty': 'Your cart is empty'
    }
    return translations[key] || key
  }

  dispatchCartUpdate() {
    const itemIds = Object.keys(this.lines).map(id => parseInt(id, 10))
    const event = new CustomEvent("cart:updated", {
      detail: { itemIds }
    })
    document.dispatchEvent(event)
  }
}
