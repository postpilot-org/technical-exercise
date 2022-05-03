module Dashboard
  class DiscountsController < ApplicationController
    RECORDS_PER_PAGE = 10

    before_action :find_discount, only: [:show, :edit]

    def index
      @discounts = Discount.all.page(params[:page]).per(RECORDS_PER_PAGE)
    end

    def show
      @per_page = RECORDS_PER_PAGE
      @codes = @discount.codes.page(params[:page]).per(RECORDS_PER_PAGE)
    end

    def new
      @discount = Discount.new
    end

    def edit
    end

    def create
      @discount = Discount.new(discount_params)

      if @discount.save
        redirect_to new_discount_code_batch_path(@discount),
          notice: "You are successfully created coupon. Now add your codes"
      else
        render :new
      end
    end

    private

    def discount_params
      params.require(:discount).permit(:name)
    end

    def find_discount
      @discount = Discount.find(params[:id])
    end
  end
end
