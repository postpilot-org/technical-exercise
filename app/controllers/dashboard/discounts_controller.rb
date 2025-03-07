module Dashboard
  class DiscountsController < ApplicationController
    before_action :find_discount, only: %i[edit generate_csv destroy_csv]

    RECORDS_PER_PAGE = 10

    def index
      @discounts = Discount.all.page(params[:page]).per(RECORDS_PER_PAGE)
    end

    def new
      @discount = Discount.new
    end

    def edit; end

    def create
      @discount = Discount.new(discount_params)

      if @discount.save
        redirect_to new_discount_code_batch_path(@discount),
          notice: "You are successfully created coupon. Now add your codes"
      else
        render :new
      end
    end

    def generate_csv
      unless @discount.generating_csv?
        @discount.update(csv_export_started_at: Time.zone.now)

        # perform_in emulates 5 seconds delay to
        # simulate CSV generation in large datasets
        GenerateCsvWorker.perform_in(5.seconds.from_now, @discount.id)
      end

      redirect_to discounts_path,
        notice: "CSV is being generated. Button will be updateed when ready."
    end

    def destroy_csv
      if  @discount.purge_csv!
        redirect_to discounts_path,
          notice: "CSV file is successfully deleted."
      else
        redirect_to discounts_path,
          error: "CSV file couldn't be deleted."
      end
    end

    private

      def find_discount = @discount = Discount.find(params[:id])
      def discount_params = params.require(:discount).permit(:name)
  end
end
