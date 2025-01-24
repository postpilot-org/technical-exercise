# frozen_string_literal: true

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
class Code < ApplicationRecord
  SAMPLE_VALUE = 'Feb-HnQv2'
  belongs_to :discount

  validates :value, presence: true

  enum status: {
    available: 'available',
    used: 'used'
  }
end
