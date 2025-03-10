class GenerateCsvWorker
  include Sidekiq::Worker

  def perform(discount_id)
    @discount_id = discount_id
    discount.update(csv_export_started_at: Time.zone.now, csv_export_finished_at: nil)
    discount.exported_csv.attach(io: StringIO.new(csv), filename: filename)
    discount.update(csv_export_finished_at: Time.zone.now)
    Turbo::StreamsChannel.broadcast_replace_to('discounts',
      partial: 'partials/discount',
      locals: { discount: discount },
      target: "discount_#{discount.id}"
    )
  end

  private

  def filename = "discount_#{discount.id}.csv"
  def discount = @discount ||= Discount.find(@discount_id)

  def file_url
    Rails.application.routes.url_helpers.url_for(discount.exported_csv)
  end

  def csv
    @csv ||= CSV.generate do |content|
      content << ["Code"]
      discount.codes.find_each { |code| content << [code.value] }
    end
  end
end
