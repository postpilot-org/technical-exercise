# == Schema Information
#
# Table name: discounts
#
#  id                     :bigint           not null, primary key
#  csv_export_finished_at :datetime
#  csv_export_started_at  :datetime
#  kind                   :string           default("uploaded")
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Discount < ApplicationRecord
  has_many :codes
  has_one_attached :exported_csv

  validates :name, uniqueness: true, presence: true

  enum kind: {uploaded: "uploaded"}

  def generating_csv?
    csv_export_started_at.present? && csv_export_finished_at.blank?
  end

  def purge_csv!
    ActiveRecord::Base.transaction do
      exported_csv.purge
      update(csv_export_started_at: nil, csv_export_finished_at: nil)
    end
  end
end
