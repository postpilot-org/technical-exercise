require "rails_helper"

RSpec.describe "Viewing disounts", type: :system do
  it "shows information to create a coupon" do
    visit discounts_path

    expect(page).to have_content "You have no single-use coupons."
    expect(page).not_to have_button("Create your first Coupon")
  end

  it "shows the number of Available/Total coupon codes" do
    discount = create(:discount)

    create(:code, discount: discount, status: "used")
    create(:code, discount: discount, status: "available")

    visit discounts_path

    expect(page).to have_content "#{discount.codes.available.count} / #{discount.codes.count}"
  end

  it "show coupom details with codes" do
    discount = create(:discount)

    create(:code, discount: discount, status: "available", value: "abc123")
    create(:code, discount: discount, status: "available", value: "def456")

    visit discount_path(discount)

    expect(page).to have_content "Coupon Details"

    expect(page).to have_content "abc123"
    expect(page).to have_content "def456"
  end
end
