require "rails_helper"
require "csv"
RSpec.describe Code, type: :model do
  subject(:code) { described_class.new }
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

  it { is_expected.to validate_presence_of(:value) }

  it "Validate export list of codes " do
    expect(Code.all.size).to eq 20
    expect(Code.by_discount(discount_1.id).size).to eq 10
    expect(Code.by_discount(discount_2.id).size).to eq 10
    scope_1 = Code.by_discount(discount_1.id)
    scope_2 = Code.by_discount(discount_2.id)
    expect(Code.to_csv(scope_1)).to eq generate_csv(scope_1)
    expect(Code.to_csv(scope_1)).to_not eq generate_csv(scope_2)
    expect(Code.to_csv(scope_2)).to eq generate_csv(scope_2)
    expect(Code.to_csv(scope_2)).to_not eq generate_csv(scope_1)
  end

  def generate_csv(scope)
    CSV.generate do |csv|
      csv << ["code"]
      scope.all.each do |code|
        csv << [code.value]
      end
    end
  end
end
