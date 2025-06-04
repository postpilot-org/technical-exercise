require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe GenerateCodesWorker, type: :worker do
  let(:discount) { create(:discount) }

  before do
    Sidekiq::Testing.fake!
  end

  describe '#perform' do
    it 'generates the CodeSet export file' do
      # No need to actually generate the file as we already test this on CodeSet#generate
      code_set_double = instance_double('CodeSet')
      allow(discount).to receive(:code_set).and_return(code_set_double)
      allow(Discount).to receive(:find).with(discount.id).and_return(discount)

      expect(code_set_double).to receive(:generate)

      Sidekiq::Testing.inline! do
        GenerateCodesWorker.perform_async(discount.id)
      end
    end

    it 'fails if CodeSet is not present for that Discount' do
      discount = create(:discount, code_set: nil)

      Sidekiq::Testing.inline!

      expect {
        GenerateCodesWorker.perform_async(discount.id)
      }.to raise_error(GenerateCodesWorker::PreconditionError)
    end
  end
end
