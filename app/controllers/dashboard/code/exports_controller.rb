# frozen_string_literal: true

module Dashboard
  module Code
    class ExportsController < ApplicationController
      def create
        discount = Discount.find(params[:discount_id])
        export = DiscountCodesExport.create!(discount: discount)
        redirect_to discount_code_export_path(discount, export)
      end

      def show
        @discount = Discount.find(params[:discount_id])
        @export = @discount.discount_codes_exports.find(params[:id])
      end
    end
  end
end
