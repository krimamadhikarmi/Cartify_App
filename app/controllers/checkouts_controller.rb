class CheckoutsController < ApplicationController
  def create
    secret_key = Rails.application.credentials.stripe[:secret_key]
    Stripe.api_key = secret_key

    cart = params[:cart]
    return render json: { error: "Cart is empty" }, status: 400 if cart.blank?

    session[:line_items] = cart.map do |item|
      product = Product.find_by(id: item["id"])
      product_stock = product.stocks.find_by(size: item["size"])

      if product_stock.nil? || product_stock.amount < item["quantity"].to_i
        return render json: { error: "Not enough stock for #{item['name']} in size #{item['size']}. Only #{product_stock&.amount || 0} left." }, status: 400
      end

      {
        quantity: item["quantity"].to_i,
        price_data: {
          product_data: {
            name: item["name"],
            metadata: { product_id: product.id, size: item["size"], product_stock_id: product_stock.id }
          },
          currency: "usd",
          unit_amount: item["price"].to_i
        }
      }
    end
  
    check = Stripe::Checkout::Session.create(
      mode: "payment",
      line_items: session[:line_items],
      success_url: "http://localhost:3000/success",
      cancel_url: "http://localhost:3000/cancel",
      shipping_address_collection: {
        allowed_countries: ['US', 'CA']
      }
    )
    render json: { url: check.url }
  end

  def success

    
    line_items = session[:line_items]

      line_items.each do |item|
        product =Product.find_by(id: item["price_data"]["product_data"]["metadata"]["product_id"])
        product_stock_id = item["price_data"]["product_data"]["metadata"]["product_stock_id"]
        quantity = item["quantity"].to_i

        stock = product.stocks.find_by(id: product_stock_id)
        # binding.irb
        stock.decrement!(:amount,quantity)
        stock.save
      end
      session[:line_items]=[]
      
      flash[:success] = "Order Successful"
      redirect_to root_path
  end

  def cancel
    render :cancel
  end
end











