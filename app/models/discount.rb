# frozen_string_literal: true

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

  validates :name, uniqueness: true, presence: true

  enum kind: { uploaded: 'uploaded' }
end
