class UploadCodesWorker
  include Sidekiq::Worker
  sidekiq_options queue: :csv

  def perform(values, discount_id)
    Code.import(
      values.map { |value| {value: value.strip, discount_id: discount_id} },
      on_duplicate_key_ignore: true
    )
  end
end
