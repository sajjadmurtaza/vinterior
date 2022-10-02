# frozen_string_literal: true

require_relative 'product'

class Checkout
  attr_reader :cart, :promotions

  def initialize(promotions: [])
    @cart = []
    @promotions = promotions
  end

  def scan(product)
    return "error: #{product} is not a valid product" unless valid_product?(product)

    @cart << product
  end

  def total
    total = 0

    @cart.each { |p| total += p.price }

    @promotions.each do |promotion|
      total = promotion.run(cart: @cart, total:)
    end

    total.round(2)
  end

  private

  def valid_product?(product)
    Product.all.include?(product)
  end
end
