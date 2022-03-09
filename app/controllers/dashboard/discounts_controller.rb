module Dashboard
  class DiscountsController < ApplicationController
    RECORDS_PER_PAGE = 10

    def index
      @discounts = Discount.all.page(params[:page]).per(RECORDS_PER_PAGE)
    end

    def new
      @discount = Discount.new
    end

    def edit
      @discount = Discount.find(params[:id])
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
  end
end
