class GenerateCodesWorker
  include Sidekiq::Worker
  sidekiq_options queue: :csv

  class PreconditionError < StandardError; end

  def perform(discount_id)
    discount = Discount.find(discount_id)
    if discount.code_set.blank?
      raise PreconditionError, "cannot generate file for Discount with no CodeSet"
    end

    discount.code_set.generate
  end
end
