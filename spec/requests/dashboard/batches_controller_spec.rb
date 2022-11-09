require "rails_helper"
require 'sidekiq/testing' 

describe 'Batches', type: :request do
  let(:discount_1) { Discount.create(name: "ABC") }
  it 'schedules download worker' do
    Sidekiq::Testing.fake! { get download_discount_code_batches_path(discount_1) }
    expect(DownloadCodesWorker.jobs.size).to eq(1)
  end
end