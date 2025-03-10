# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateCsvWorker, type: :worker do
  describe '#perform' do
    subject(:worker) { described_class.new }
    let(:discount) { create(:discount) }

    before do
      @host = Rails.application.routes.default_url_options[:host]
      Rails.application.routes.default_url_options[:host] = 'test'
    end

    after { Rails.application.routes.default_url_options[:host] = @host }

    it 'creates a CSV file', :aggregate_failures do
      expect(Turbo::StreamsChannel).to receive(:broadcast_replace_to).with(discount,
        partial: 'partials/discount',
        locals: { discount: discount },
        target: "discount_#{discount.id}"
      )

      expect { worker.perform(discount.id) && discount.reload }
        .to change(ActiveStorage::Attachment, :count).by(1)
    end
  end
end
