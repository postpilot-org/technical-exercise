module Dashboard
  module Code
    class BatchesController < ApplicationController
      PER_GROUP = 5_000
      RECORDS_PER_PAGE = 10
      before_action :set_discount

      def index
        @codes = @discount.codes.page(params[:page]).per(RECORDS_PER_PAGE)
      end

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
        job = DownloadCodesWorker.perform_async(@discount.id)
        respond_to do |format|
          format.html {
            redirect_to discounts_path
          }
          format.json do
            render json: {
              job: job
            }, status: ok
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
