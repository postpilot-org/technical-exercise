class DownloadCodesWorker
  include Sidekiq::Worker
  sidekiq_options queue: :csv

  # after_perform do
  #   #action cable goes here
  #   # ActionCable.server.broadcast 'background_file_channel', content: 'hello'
  # end

  def perform(discount_id)
    attributes = %w{value status}.freeze
    # This is safe as it's not user input, but constants
    codes = Code.where(discount_id: discount_id).pluck(attributes.join(","))    

    csv = CSV.generate(headers: true) do |csv|
      csv << attributes
      codes.each do |code|
        csv << code
      end
    end

    ActionCable.server.broadcast "file_downloader_channel", {
      filename: "data.csv",
      content: csv
    }
  end
end