require "rails_helper"

RSpec.describe ExportChannel, type: :channel do
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

  it "Validate subscribe to channel" do
    subscribe
    expect(subscription).to be_confirmed
  end

  it "Validate send properly csv file through channel" do
    scope_1 = Code.by_discount(discount_1.id)
    expect {
      ActionCable.server.broadcast(
        "export_channel", {filename: "test", content: Code.to_csv(scope_1)}
      )
    }.to have_broadcasted_to("export_channel").with { |data| expect(data["content"]).to eq generate_csv(scope_1) }
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
