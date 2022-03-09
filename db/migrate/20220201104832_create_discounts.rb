class CreateDiscounts < ActiveRecord::Migration[6.1]
  def change
    create_table :discounts do |t|
      t.string :kind, default: "uploaded"
      t.string :name

      t.timestamps
    end
  end
end
