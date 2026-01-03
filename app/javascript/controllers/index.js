import { Application } from "@hotwired/stimulus"
import CartController from "./cart_controller"
window.Stimulus = Application.start()
Stimulus.register("cart", CartController)
