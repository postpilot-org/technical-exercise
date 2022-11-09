require "rails_helper"

RSpec.describe Code, type: :model do
  subject(:code) { described_class.new }



  it { is_expected.to validate_presence_of(:value) }


  context "a couple of codes with a discount" do

    let(:discount_1) { Discount.create(name: "Disco 1") }
    let(:discount_2) { Discount.create(name: "Disco 2") }

    before do
      Code.create(value: "A", discount_id: discount_1.id, status: :available)
      Code.create(value: "B", discount_id: discount_1.id, status: :available)
      Code.create(value: "C", discount_id: discount_2.id, status: :available)
    end

    it "Validate scoping by_discount_id" do
      expect(Code.by_discount_id(discount_1.id).count).to eq 2
      expect(Code.by_discount_id(discount_1.id).first.value).to eq "A"
      expect(Code.by_discount_id(discount_2.id).count).to eq 1
      expect(Code.by_discount_id(discount_2.id).first.value).to eq "C"
    end
  end

end
