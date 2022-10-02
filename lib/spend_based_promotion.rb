# frozen_string_literal: true

require 'promotion'

class SpendBasedPromotion < Promotion
  def run(cart:, total:)
    return total unless total >= @spend_limit

    total - (total.to_f / 100) * @discount_percentage
  end
end
