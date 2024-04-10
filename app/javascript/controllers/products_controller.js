import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="products"
export default class extends Controller {
  static values ={size: String, product: Object}
  
  addToCart() {
    console.log("Product:", this.productValue)
    const cart = localStorage.getItem("cart") //check whether the user has cart or not
    if (cart){ //if it has we add item to that cart otherwise create a new cart
      const cartArray =JSON.parse(cart)
      const foundIndex = cartArray.findIndex(item => item.id === this.productValue.id && item.size === this.sizeValue)
      if (foundIndex >=0){
         cartArray[foundIndex].quantity =parseInt(cartArray[foundIndex].quantity+1)
      }
      else{
          cartArray.push({
            id: this.productValue.id,
            name: this.productValue.name,
            price: this.productValue.price,
            size: this.sizeValue,
            quantity:1
          })
      }
      localStorage.setItem("cart",JSON.stringify(cartArray))
    }
    
    else{
      const cartArray=[]
      cartArray.push(
        {
          id: this.productValue.id,
          name: this.productValue.name,
          price: this.productValue.price,
          size: this.sizeValue,
          quantity:1
        }
      )
      localStorage.setItem("cart",JSON.stringify(cartArray))
    }
  }

  selectSize(e) {
    this.sizeValue = e.target.value
    const selectedSizeEl = document.getElementById("selected-size") 
    if (selectedSizeEl) {
        selectedSizeEl.innerText = `Selected Size: ${this.sizeValue}`
    } else {
        console.error("Element with id 'selected-size' not found.")
    }
  }
}
