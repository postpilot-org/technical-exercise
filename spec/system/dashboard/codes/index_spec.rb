require "rails_helper"

RSpec.describe "Viewing codes", type: :system do
  let(:discount_1) { Discount.create(name: "Test 1") }
  let(:discount_2) { Discount.create(name: "Test 2") }
  before do
    (1..10).each do |i|
      Code.create(value: SecureRandom.hex(4), discount_id: discount_1.id, status: :available)
    end
    (1..10).each do |x|
      Code.create(value: SecureRandom.hex(4), discount_id: discount_2.id, status: :available)
    end
  end

  it "List all codes associates to a discount" do
    visit discount_code_codes_path(discount_1)
    expect(page).to have_content "Showing 10 of #{discount_1.codes.count}"
    within "table" do
      discount_1.codes.each do |code|
        expect(page).to have_text code.value
      end
    end
    visit discount_code_codes_path(discount_2)
    expect(page).to have_content "Showing 10 of #{discount_2.codes.count}"
    within "table" do
      discount_2.codes.each do |code|
        expect(page).to have_text code.value
      end
    end
  end
end
