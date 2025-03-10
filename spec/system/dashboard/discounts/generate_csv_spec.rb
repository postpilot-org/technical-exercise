# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating a discount', type: :system do
  subject { post generate_csv_discount_path(discount) }
  let(:discount) { create(:discount) }

  it 'enqueues a discount csv generate' do
    expect { subject }.to change { GenerateCsvWorker.jobs.size }.by(1)
    expect(response).to redirect_to(discounts_path)
  end
end
