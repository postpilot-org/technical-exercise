class DownloadCodesWorker
    include Sidekiq::Worker

    def perform(discount_id)
      #Simulate slowdown a large creation of csv
      sleep(10)
      codes = Code.where(discount_id: discount_id)
      ActionCable.server.broadcast "export_channel", {
          filename: 'data.csv',
          content: Code.to_csv(codes)
        }
    end
end