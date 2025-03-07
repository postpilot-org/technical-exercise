module DiscountHelper
  def discount_link_title(discount)
    return 'Download CSV' if discount.exported_csv.attached?
    return 'Generating...' if discount.csv_export_started_at.present?

    'Generate CSV'
  end

  def discount_link_url(discount)
    return url_for(discount.exported_csv) if discount.exported_csv.attached?
    return '#' if discount.csv_export_started_at.present?

    generate_csv_discount_path(discount)
  end
end
