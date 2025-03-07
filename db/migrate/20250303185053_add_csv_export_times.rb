class AddCsvExportTimes < ActiveRecord::Migration[7.0]
  def change
    add_column :discounts, :csv_export_started_at, :datetime
    add_column :discounts, :csv_export_finished_at, :datetime
  end
end
