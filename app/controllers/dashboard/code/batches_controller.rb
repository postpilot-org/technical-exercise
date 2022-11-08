module Dashboard
  module Code
    class BatchesController < ApplicationController
      PER_GROUP = 5_000

      before_action :set_discount

      def new
      end

      def create
        respond_to do |format|
          format.html do
            redirect_to discounts_path, notice: "Your coupon codes are being processed - check back in a minute"
          end

          format.json do
            codes = params[:codes] || ""

            codes.split(",").in_groups_of(PER_GROUP, false) do |codes_values|
              UploadCodesWorker.perform_async(codes_values, @discount.id)
            end

            render json: nil, status: :ok
          end
        end
      end

      def download
        respond_to do |format|
          format.html do
            DownloadCodesWorker.perform_async(@discount.id)            
            redirect_to discounts_path, notice: "Your coupons codes for #{@discount.name} are being generated into a CSV!"
          end
        end
      end

      private

      def set_discount
        @discount = Discount.find(params[:discount_id])
      end
    end
  end
end
