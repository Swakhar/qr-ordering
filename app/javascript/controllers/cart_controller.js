import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lines", "total", "payload"]
  connect() { this.lines = {} }

  add(event) {
    event.preventDefault()
    const id = parseInt(event.params.itemId, 10)
    this.lines[id] = (this.lines[id] || 0) + 1
    this.render()
  }
  sub(event) {
    event.preventDefault()
    const id = parseInt(event.params.itemId, 10)
    if (!this.lines[id]) return
    this.lines[id]--
    if (this.lines[id] <= 0) delete this.lines[id]
    this.render()
  }
  async checkout(event) {
    event.preventDefault()
    const items = Object.entries(this.lines).map(([id, qty]) => ({ item_id: parseInt(id,10), qty }))
    this.payloadTarget.value = JSON.stringify(items)
    this.element.requestSubmit()
  }

  render() {
    const entries = Object.entries(this.lines)
    if (!entries.length) { this.linesTarget.innerHTML = "<em>Leer</em>"; this.totalTarget.textContent = "€0,00"; return }
    let html = ""
    let total = 0
    entries.forEach(([id, qty]) => {
      const price = parseInt(document.querySelector(`[data-item-price='${id}']`)?.dataset.cents || "0",10)
      const name  = document.querySelector(`[data-item-name='${id}']`)?.dataset.name || `#${id}`
      total += price * qty
      html += `<li>${name} × ${qty}
        <button data-action="click->cart#add" data-cart-item-id-param="${id}">+</button>
        <button data-action="click->cart#sub" data-cart-item-id-param="${id}">−</button>
      </li>`
    })
    this.linesTarget.innerHTML = `<ul>${html}</ul>`
    this.totalTarget.textContent = new Intl.NumberFormat("de-DE", { style:"currency", currency:"EUR"}).format(total/100)
  }
}
