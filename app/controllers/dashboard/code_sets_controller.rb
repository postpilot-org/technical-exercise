
module Dashboard
  class CodeSetsController < ApplicationController
    before_action :set_discount

    def create
      @discount.create_code_set if @discount.code_set.blank?
      GenerateCodesWorker.perform_async(@discount.id)

      respond_to do |format|
        format.html do
          redirect_to discounts_path, notice: 'Your export file is being generated - check back in a minute.'
        end
      end
    end

    private

    def set_discount
      @discount = Discount.find(params[:discount_id])
    end
  end
end
