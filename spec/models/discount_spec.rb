require "rails_helper"

RSpec.describe Discount, type: :model do
  subject(:discount) { described_class.new }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe '#generating_csv?' do
    subject { discount.generating_csv? }

    context 'when csv_export_started_at and csv_export_finished_at are blank' do
      let(:discount) { create(:discount) }

      it { is_expected.to eq(false) }
    end

    context 'when csv_export_started_at is present and csv_export_finished_at is blank' do
      let(:discount) { create(:discount, csv_export_started_at: Time.zone.now) }

      it { is_expected.to eq(true) }
    end

    context 'when csv_export_started_at and csv_export_finished_at are present' do
      let(:discount) do
        create(:discount, csv_export_started_at: Time.zone.now, csv_export_finished_at: Time.zone.now)
      end

      it { is_expected.to eq(false) }
    end
  end
end
