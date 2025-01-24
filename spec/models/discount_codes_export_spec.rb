# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscountCodesExport, type: :model do
  include ActiveJob::TestHelper

  context 'when created' do
    it 'creates a CSV' do
      discounts = create_list(:discount, 2)
      create_list(:code, 3, discount: discounts[0])
      create_list(:code, 2, discount: discounts[1])
      perform_enqueued_jobs do
        export = DiscountCodesExport.create!(discount: discounts[0])
        csv = CSV.parse(export.csv.download, headers: true)
        expect(csv.length).to eql(3)
        expect(csv.pluck('value')).to match_array(discounts[0].codes.pluck(:value))
        expect(csv[0]['status']).to eql('available')
      end
    end
  end
end
