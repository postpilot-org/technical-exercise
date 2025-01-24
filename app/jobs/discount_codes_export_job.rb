# frozen_string_literal: true

class DiscountCodesExportJob < ApplicationJob
  def perform(export)
    csv = create_csv export.discount
    io = create_tmp_file(csv)
    export.csv.attach(io:, filename: 'codes.csv')
  end
  
  private

  def create_tmp_file(csv)
    Tempfile.new.tap do |io|
      io.write(csv)
      io.rewind
    end
  end

  def create_csv(discount)
    CSV.generate do |csv|
      csv << %w[value status]
      discount.codes.find_each do |code|
        csv << [code.value, code.status]
      end
    end
  end
end
