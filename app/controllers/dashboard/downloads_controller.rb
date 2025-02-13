# frozen_string_literal: true

module Dashboard
  class DownloadsController < ApplicationController
    def show
      redis_key = params[:key]
      csv_data = $redis.get(redis_key)
      
      if csv_data.present?
        # Retrieve metadata, if available, for the original discount name
        metadata = $redis.get("#{redis_key}:metadata")
        
        discount_name =
          if metadata.present?
            JSON.parse(metadata)['name']
          else
            # Fallback to parsing the key if no metadata exists (for backwards compatibility)
            key_parts = redis_key.split(':')
            key_parts[2].presence || 'discount'
          end
        
        filename = "#{discount_name.presence || 'discount'}_codes.csv"
        
        send_data csv_data,
                  filename: filename,
                  type: "text/csv",
                  disposition: "attachment"
      else
        redirect_to discounts_path, alert: "Export file has expired. Please generate a new export."
      end
    end
  end
end 