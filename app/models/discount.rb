# == Schema Information
#
# Table name: discounts
#
#  id         :bigint           not null, primary key
#  kind       :string           default("uploaded")
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Discount < ApplicationRecord
  has_many :codes
  has_one :code_set

  validates :name, uniqueness: true, presence: true

  enum kind: {uploaded: "uploaded"}

  def export_file
    code_set&.file
  end
end
