# == Schema Information
#
# Table name: code_sets
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  discount_id :bigint
#
# Indexes
#
#  index_code_sets_on_discount_id  (discount_id)
#
class CodeSet < ApplicationRecord
  belongs_to :discount

  has_one_attached :file

  def discount_codes
    discount.codes
  end

  # Generates and saves a CSV representation of the CodeSet to the `file`
  # attachment.
  def generate(filename: 'codes.csv')
    file.attach(io: StringIO.new(to_csv), filename: filename, content_type: 'text/csv')
  end

  # Generates a CSV string with all of the discount's codes, including their
  # usage status.
  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[code status]

      discount_codes.find_each do |code|
        csv << [code.value, code.status]
      end
    end
  end
end
