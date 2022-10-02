# frozen_string_literal: true

class Product
  include ObjectSpace

  attr_reader :product_code, :name, :price

  def initialize(product_code:, name:, price:)
    @product_code = product_code
    @name = name
    @price = price
  end

  def self.all
    ObjectSpace.each_object(self).to_a
  end
end

# Product.new(product_code: '0o01', name: 'Product one', price: 10)
# Product.new(product_code: '0o01', name: 'Product two', price: 70)
# Product.all
