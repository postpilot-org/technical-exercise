# == Schema Information
#
# Table name: codes
#
#  id          :bigint           not null, primary key
#  status      :string           default("available"), not null
#  value       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  discount_id :bigint
#
# Indexes
#
#  index_codes_on_discount_id        (discount_id)
#  index_codes_on_status             (status)
#  index_codes_on_value  (value) UNIQUE
#
require 'csv'
class Code < ApplicationRecord
  SAMPLE_VALUE = "Feb-HnQv2".freeze
  belongs_to :discount

  validates :value, presence: true
  scope :by_discount, ->(discount_id) { where(discount_id: discount_id) }

  enum status: {
    available: "available",
    used: "used"
  }

  def self.to_csv(scope)
    CSV.generate do |csv|
      csv << ['code']
      scope.all.each do |code|
        csv << [code.value]
      end
    end
  end
end
