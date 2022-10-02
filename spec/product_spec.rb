# frozen_string_literal: true

require 'product'

describe Product do
  let(:product) { Product.new(product_code: '10o01', name: 'Product one', price: 10) }

  it 'returns a product_code' do
    expect(product.product_code).to eq '10o01'
  end

  it 'returns a product name' do
    expect(product.name).to eq 'Product one'
  end

  it 'returns a product price' do
    expect(product.price).to eq 10
  end

  context '#all' do
    before { product }

    it 'return all products' do
      expect(Product.all).to include(product)
    end
  end
end
