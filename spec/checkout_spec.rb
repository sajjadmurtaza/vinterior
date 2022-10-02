# frozen_string_literal: true

require 'checkout'
require 'items_based_promotion'
require 'spend_based_promotion'

describe Checkout do
  let(:subject) { Checkout.new(promotions:) }

  let(:product_one) { Product.new(product_code: '10o01', name: 'Product one', price: 10) }
  let(:product_two) { Product.new(product_code: '10o02', name: 'Product two', price: 30) }
  let(:product_three) { Product.new(product_code: '10o03', name: 'Product three', price: 50) }
  let(:product_four) { Product.new(product_code: '10o04', name: 'Product four', price: 80) }

  let(:promotions) do
    [
      ItemsBasedPromotion.new(discount_percentage: 0.75, product_code: '10o01', min_quantity: 2),
      SpendBasedPromotion.new(discount_percentage: 10, spend_limit: 60)
    ]
  end

  before do
    product_one
    product_two
    product_three
    product_four

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

          total = subject.total

          expect(total).not_to eq(product_one.price + product_one.price)
          expect(total).to eq(18.5)
        end

        it 'does apply items spend based promotion' do
          subject.scan(product_four)

          total = subject.total

          expect(total).not_to eq(product_four)
          expect(total).to eq(72.0)
        end
      end
    end
  end
end
