#frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscountHelper, type: :helper do
  describe '#discount_link_url' do
    let(:discount) { create(:discount) }
    let(:file) { File.open(Rails.root.join('spec', 'fixtures', 'files', 'sample.pdf')) }

    context 'when discount has attached exported_csv' do
      before do
        discount.exported_csv.attach(io: file, filename: 'discounts.csv')
      end

      it 'returns the url for the attached file' do
        expect(helper.discount_link_url(discount)).to eq(url_for(discount.exported_csv))
      end
    end

    context 'when discount has csv_export_started_at' do
      let(:discount) { create(:discount, csv_export_started_at: Time.zone.now) }

      it 'returns "#" as the url' do
        expect(helper.discount_link_url(discount)).to eq('#')
      end
    end

    context 'when discount does not have attached exported_csv and csv_export_started_at' do
      it 'returns the url for generating the csv' do
        expect(helper.discount_link_url(discount)).to eq(generate_csv_discount_path(discount))
      end
    end
  end
end
