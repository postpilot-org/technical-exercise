require 'rails_helper'

RSpec.describe CodeSet, type: :model do
  subject(:code_set) { create(:code_set) }

  describe '#generate' do
    before do
      create_list(:code, 2, discount: code_set.discount)
    end

    it 'populates the attached file with the CSV representation' do
      code_set.generate
      expect(code_set.file.download).to eq code_set.to_csv
    end
  end

  describe '#to_csv' do
    let(:available) { create(:code, status: 'available', discount: code_set.discount) }
    let(:used) { create(:code, status: 'available', discount: code_set.discount) }

    it 'generates a CSV representation as string' do
      expected = CSV.generate(headers: true) do |csv|
        csv << %w[code]
        csv << [available.value]
        csv << [used.value]
      end

      expect(subject.to_csv).to eq expected
    end
  end
end
