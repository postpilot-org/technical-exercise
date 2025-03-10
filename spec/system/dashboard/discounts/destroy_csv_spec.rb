# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating a discount', type: :system do
  subject { delete destroy_csv_discount_path(discount) }
  let(:discount) { create(:discount, :with_exported_csv) }

  it 'destroys csv' do
    expect { subject && discount.reload }
      .to change { discount.exported_csv.attached? }.from(true).to(false)
      .and change(discount, :csv_export_started_at).to(nil)
      .and change(discount, :csv_export_finished_at).to(nil)
  end
end
