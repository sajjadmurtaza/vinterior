# frozen_string_literal: true

require 'checkout'
require 'items_based_promotion'
require 'spend_based_promotion'

describe Checkout do
  let(:subject) { Checkout.new(promotions:) }

  let(:product_one) { Product.new(product_code: '001', name: 'Product one', price: 9.25) }
  let(:product_two) { Product.new(product_code: '002', name: 'Product two', price: 45.00) }
  let(:product_three) { Product.new(product_code: '003', name: 'Product three', price: 19.95) }

  let(:promotions) do
    [
      ItemsBasedPromotion.new(discount_percentage: 0.75, product_code: '001', min_quantity: 2),
      SpendBasedPromotion.new(discount_percentage: 10, spend_limit: 60)
    ]
  end

  before do
    product_one
    product_two
    product_three

    promotions
  end

  describe '#scan' do
    context 'when valid products are being scanned' do
      it 'successfully adds the product to the cart' do
        subject.scan(product_one)

        expect(subject.cart.count).to eq 1
      end

      context 'when shopping does not meet any promotion criteria' do
        it 'does not apply any discount' do
          subject.scan(product_one)

          total = subject.total

          expect(total).to eq(product_one.price)
        end

        it 'does not apply any discount' do
          subject.scan(product_one)
          subject.scan(product_two)

          total = subject.total

          expect(total).to eq(product_one.price + product_two.price)
        end
      end

      context 'when shopping meet the promotion criteria(s)' do
        it 'does apply items based promotion' do
          subject.scan(product_one)
          subject.scan(product_one)
          subject.scan(product_three)

          total = subject.total

          expect(total).not_to eq(product_one.price + product_one.price + product_three.price)
          expect(total).to eq(36.95)
        end

        it 'does apply spend based promotion' do
          subject.scan(product_one)
          subject.scan(product_two)
          subject.scan(product_three)

          total = subject.total

          expect(total).not_to eq(product_one.price + product_two.price + product_three.price)
          expect(total).to eq(66.78)
        end

        it 'do apply both items spend based promotion and spend based promotion' do
          subject.scan(product_one)
          subject.scan(product_two)
          subject.scan(product_one)
          subject.scan(product_three)

          total = subject.total

          expect(total).not_to eq(product_one.price + product_two.price + product_one.price + product_three.price)
          expect(total).to eq(73.76)
        end
      end
    end
  end
end
