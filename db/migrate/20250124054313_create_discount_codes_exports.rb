# frozen_string_literal: true

class CreateDiscountCodesExports < ActiveRecord::Migration[7.0]
  def change
    create_table :discount_codes_exports do |t|
      t.references :discount, null: false, foreign_key: true

      t.timestamps
    end
  end
end
