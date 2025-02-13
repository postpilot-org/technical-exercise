class ExportCodesWorker
  include Sidekiq::Worker
  sidekiq_options queue: :csv

  REDIS_KEY_PREFIX = "discount_codes_export"
  REDIS_TTL = 1.hour.to_i # Files expire after 1 hour

  def perform(discount_id)
    discount = Discount.find(discount_id)
    
    csv_data = CSV.generate do |csv|
      csv << ["code"] # header row
      # Use find_each for batching in large datasets
      discount.codes.find_each do |code|
        csv << [code.value]
      end
    end

    # Sanitize discount name for Redis key purposes
    Rails.logger.info "Original discount name: #{discount.name.inspect}"
    sanitized_name = discount.name.to_s.gsub(/[^a-zA-Z0-9\-_]/, '_')
    Rails.logger.info "Sanitized discount name: #{sanitized_name.inspect}"
    
    # Store original name in Redis for filename retrieval
    metadata = { name: discount.name, sanitized_name: sanitized_name }.to_json
    redis_key = "#{REDIS_KEY_PREFIX}:#{discount_id}:#{sanitized_name}:#{Time.current.to_i}"
    Rails.logger.info "Generated Redis key: #{redis_key.inspect}"
    
    # Store metadata and CSV data in Redis, using the TTL defined above
    $redis.setex("#{redis_key}:metadata", REDIS_TTL, metadata)
    $redis.setex(redis_key, REDIS_TTL, csv_data)

    # Build a relative download URL using the proper route
    download_url = "/downloads/#{redis_key}"
    Rails.logger.info "Debug: Generated download URL: #{download_url}"

    # Trigger the download
    Turbo::StreamsChannel.broadcast_append_to(
      "discount_#{discount_id}_exports",
      target: "export_status_#{discount_id}",
      html: "<script>window.location = '#{download_url}';</script>"
    )
  rescue StandardError => e
    Rails.logger.error "Export failed: #{e.message}"
    raise
  end
end 