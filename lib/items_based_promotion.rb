# frozen_string_literal: true

require 'promotion'

class ItemsBasedPromotion < Promotion
  def run(cart:, total:)
    products = cart.select { |product| product.product_code == @product_code }

    return total unless products.length >= @min_quantity

    total - (@discount_percentage * products.length)
  end
end
