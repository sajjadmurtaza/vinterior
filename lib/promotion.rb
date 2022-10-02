# frozen_string_literal: true

class Promotion
  attr_reader :discount_percentage, :product_code, :min_quantity, :spend_limit

  def initialize(discount_percentage: 0, product_code: nil, min_quantity: nil, spend_limit: nil)
    @discount_percentage = discount_percentage
    @product_code = product_code
    @min_quantity = min_quantity
    @spend_limit = spend_limit
  end

  def run
    'error: Please provide valid promotion type(s)!'
  end
end
