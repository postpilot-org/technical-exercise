require 'rails_helper'

RSpec.describe ExportCodesWorker do
  describe '#perform' do
    let(:discount) { create(:discount, name: "Summer Sale 2024") }
    let!(:codes) { create_list(:code, 3, discount: discount) }
    let(:redis) { $redis }

    before do
      # Clear any existing Redis keys for clean testing
      redis.keys("#{described_class::REDIS_KEY_PREFIX}:*").each { |key| redis.del(key) }
    end

    it 'stores CSV data in Redis with proper TTL' do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_to)
      
      described_class.new.perform(discount.id)
      
      # Find the generated Redis key
      redis_key = redis.keys("#{described_class::REDIS_KEY_PREFIX}:#{discount.id}:*").first
      expect(redis_key).to be_present

      # Verify CSV content
      csv_data = redis.get(redis_key)
      expect(csv_data).to include("code") # Verify header
      codes.each do |code|
        expect(csv_data).to include(code.value)
      end

      # Verify TTL is set
      ttl = redis.ttl(redis_key)
      expect(ttl).to be_between(0, described_class::REDIS_TTL)

      # Verify metadata
      metadata = JSON.parse(redis.get("#{redis_key}:metadata"))
      expect(metadata["name"]).to eq("Summer Sale 2024")
      expect(metadata["sanitized_name"]).to eq("Summer_Sale_2024")
    end

    it 'broadcasts a Turbo stream with the download URL' do
      expect(Turbo::StreamsChannel).to receive(:broadcast_append_to).with(
        "discount_#{discount.id}_exports",
        target: "export_status_#{discount.id}",
        html: match(/<script>window\.location = '\/downloads\/.*';<\/script>/)
      )

      described_class.new.perform(discount.id)
    end

    it 'enqueues in the csv queue' do
      expect(described_class.sidekiq_options['queue']).to eq(:csv)
    end

    context 'when discount does not exist' do
      it 'raises an error' do
        expect {
          described_class.new.perform(-1)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    after do
      # Clean up Redis keys
      redis.keys("#{described_class::REDIS_KEY_PREFIX}:*").each { |key| redis.del(key) }
    end
  end
end 