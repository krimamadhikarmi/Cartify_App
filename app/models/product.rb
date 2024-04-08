class Product < ApplicationRecord
    has_one_attached :image
    belongs_to :category

    has_many :stocks, dependent: :destroy
    has_many :order_products

    before_create :generate_sku

  private

  def generate_sku
    loop do
      self.sku = SecureRandom.hex(5).upcase # Generating a random 5-character hexadecimal string
      break unless Product.exists?(sku: sku)
    end
  end
end
  