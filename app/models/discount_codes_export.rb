# frozen_string_literal: true

# == Schema Information
#
# Table name: discount_codes_exports
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  discount_id :bigint           not null
#
class DiscountCodesExport < ApplicationRecord
  belongs_to :discount
  has_one_attached :csv
  after_commit :enqueue, on: :create

  private

  def enqueue
    DiscountCodesExportJob.perform_later(self)
  end
end
