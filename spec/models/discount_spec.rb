require "rails_helper"

RSpec.describe Discount, type: :model do
  subject(:discount) { described_class.new }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe '#generating_csv?' do
    subject { discount.generating_csv? }

    let(:discount) { create(:discount, csv_export_started_at: start_date, csv_export_finished_at: end_date) }
    let(:start_date) { nil }
    let(:end_date) { nil }

    context 'when csv_export_started_at and csv_export_finished_at are blank' do
      it { is_expected.to eq(false) }
    end

    context 'when csv_export_started_at is present and csv_export_finished_at is blank' do
      let(:start_date) { Time.zone.now }

      it { is_expected.to eq(true) }
    end

    context 'when csv_export_started_at is blank and csv_export_finished_at is present' do
      let(:start_date) { Time.zone.now }
      let(:end_date) { Time.zone.now }

      it { is_expected.to eq(false) }
    end
  end
end
